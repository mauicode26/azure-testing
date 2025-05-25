import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { createClient } from 'redis';
import { EventHubProducerClient } from '@azure/event-hubs';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

// Redis client setup
const redisClient = createClient({
  socket: {
    host: process.env.REDIS_HOST,
    port: 6380,
    tls: true
  },
  password: process.env.REDIS_PASSWORD
});

// Event Hub client
const eventHubClient = new EventHubProducerClient(
  process.env.EVENTHUB_CONNECTION_STRING || '',
  'loan-applications'
);

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Connect to Redis
redisClient.connect().catch(console.error);

// Loan application interface
interface LoanApplication {
  id: string;
  applicantName: string;
  email: string;
  phoneNumber: string;
  annualIncome: number;
  loanAmount: number;
  loanPurpose: string;
  creditScore?: number;
  employmentStatus: string;
  timestamp: string;
  status: 'pending' | 'approved' | 'rejected';
}

// Calculate loan eligibility
function calculateEligibility(application: LoanApplication): {
  eligible: boolean;
  interestRate: number;
  maxLoanAmount: number;
  reasoning: string;
} {
  const debtToIncomeRatio = application.loanAmount / application.annualIncome;
  const creditScore = application.creditScore || 650; // Default if not provided
  
  let baseRate = 5.5;
  let maxLoan = application.annualIncome * 4; // 4x annual income max
  
  // Adjust based on credit score
  if (creditScore >= 750) {
    baseRate = 3.5;
    maxLoan = application.annualIncome * 5;
  } else if (creditScore >= 700) {
    baseRate = 4.5;
    maxLoan = application.annualIncome * 4.5;
  } else if (creditScore < 600) {
    baseRate = 8.5;
    maxLoan = application.annualIncome * 2;
  }
  
  // Check eligibility
  const eligible = debtToIncomeRatio <= 0.4 && 
                  creditScore >= 550 && 
                  application.loanAmount <= maxLoan &&
                  application.employmentStatus !== 'unemployed';
  
  const reasoning = eligible 
    ? 'Application meets all criteria for approval'
    : 'Application does not meet minimum requirements';
  
  return {
    eligible,
    interestRate: baseRate,
    maxLoanAmount: maxLoan,
    reasoning
  };
}

// Routes
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.post('/api/loan/apply', async (req, res) => {
  try {
    const applicationId = `loan_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    
    const application: LoanApplication = {
      id: applicationId,
      ...req.body,
      timestamp: new Date().toISOString(),
      status: 'pending'
    };
    
    // Calculate eligibility
    const eligibility = calculateEligibility(application);
    application.status = eligibility.eligible ? 'approved' : 'rejected';
    
    // Store in Redis cache
    await redisClient.setEx(
      `loan:${applicationId}`, 
      3600, // 1 hour TTL
      JSON.stringify(application)
    );
    
    // Send event to Event Hub
    const eventData = {
      body: {
        applicationId,
        applicantName: application.applicantName,
        loanAmount: application.loanAmount,
        status: application.status,
        timestamp: application.timestamp,
        eligibility
      }
    };
    
    await eventHubClient.sendBatch([eventData]);
    
    res.status(201).json({
      applicationId,
      status: application.status,
      eligibility,
      message: application.status === 'approved' 
        ? 'Congratulations! Your loan application has been approved.'
        : 'Unfortunately, your loan application does not meet our current criteria.'
    });
    
  } catch (error) {
    console.error('Error processing loan application:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/loan/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const cachedData = await redisClient.get(`loan:${id}`);
    
    if (!cachedData) {
      return res.status(404).json({ error: 'Loan application not found' });
    }
    
    const application = JSON.parse(cachedData);
    res.json(application);
    
  } catch (error) {
    console.error('Error fetching loan application:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/loan/status/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const cachedData = await redisClient.get(`loan:${id}`);
    
    if (!cachedData) {
      return res.status(404).json({ error: 'Loan application not found' });
    }
    
    const application = JSON.parse(cachedData);
    res.json({
      applicationId: application.id,
      status: application.status,
      timestamp: application.timestamp
    });
    
  } catch (error) {
    console.error('Error fetching loan status:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get loan statistics
app.get('/api/stats', async (req, res) => {
  try {
    // This would typically come from a database
    // For demo purposes, returning mock data
    res.json({
      totalApplications: 1247,
      approvedApplications: 891,
      rejectedApplications: 356,
      averageLoanAmount: 28500,
      approvalRate: 71.4,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, () => {
  console.log(`example example Loan API running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
});
