const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const client = require('prom-client');
const { EventHubProducerClient } = require('@azure/event-hubs');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3002;

// Prometheus metrics
const register = new client.Registry();
client.collectDefaultMetrics({ register });

const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_ms',
  help: 'Duration of HTTP requests in ms',
  labelNames: ['route', 'method', 'status_code'],
  buckets: [1, 5, 15, 50, 100, 500]
});

const vehicleDataCounter = new client.Counter({
  name: 'vehicle_data_events_total',
  help: 'Total number of vehicle data events processed'
});

register.registerMetric(httpRequestDuration);
register.registerMetric(vehicleDataCounter);

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 1000
});
app.use(limiter);

// Metrics middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    httpRequestDuration
      .labels(req.route?.path || req.path, req.method, res.statusCode)
      .observe(duration);
  });
  next();
});

// Mock vehicle data generator
function generateVehicleData() {
  return {
    vehicleId: `example${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}`,
    timestamp: new Date().toISOString(),
    location: {
      lat: 42.3601 + (Math.random() - 0.5) * 0.1,
      lng: -71.0589 + (Math.random() - 0.5) * 0.1
    },
    telemetry: {
      speed: Math.floor(Math.random() * 80) + 20,
      rpm: Math.floor(Math.random() * 3000) + 1000,
      fuelLevel: Math.floor(Math.random() * 100),
      engineTemp: Math.floor(Math.random() * 50) + 180,
      odometer: Math.floor(Math.random() * 100000) + 10000,
      batteryVoltage: 12.0 + Math.random() * 2,
      tirePressure: {
        frontLeft: 30 + Math.random() * 5,
        frontRight: 30 + Math.random() * 5,
        rearLeft: 30 + Math.random() * 5,
        rearRight: 30 + Math.random() * 5
      }
    },
    diagnostics: {
      engineLight: Math.random() < 0.05,
      oilPressure: Math.random() < 0.02 ? 'low' : 'normal',
      brakeFluid: Math.random() < 0.01 ? 'low' : 'normal'
    }
  };
}

// Routes
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    service: 'vehicle-telemetry-api',
    timestamp: new Date().toISOString() 
  });
});

app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
  } catch (ex) {
    res.status(500).end(ex);
  }
});

app.get('/api/vehicle/telemetry/:vehicleId', (req, res) => {
  const { vehicleId } = req.params;
  const data = generateVehicleData();
  data.vehicleId = vehicleId;
  
  vehicleDataCounter.inc();
  
  res.json(data);
});

app.get('/api/vehicle/fleet-status', (req, res) => {
  const fleetSize = 50;
  const vehicles = [];
  
  for (let i = 0; i < fleetSize; i++) {
    vehicles.push(generateVehicleData());
  }
  
  vehicleDataCounter.inc(fleetSize);
  
  res.json({
    totalVehicles: fleetSize,
    timestamp: new Date().toISOString(),
    vehicles: vehicles
  });
});

app.post('/api/vehicle/alert', (req, res) => {
  const { vehicleId, alertType, severity, message } = req.body;
  
  const alert = {
    id: `alert_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    vehicleId,
    alertType,
    severity,
    message,
    timestamp: new Date().toISOString(),
    status: 'active'
  };
  
  // In a real scenario, this would send to Event Hub
  console.log('Vehicle Alert:', alert);
  
  res.status(201).json(alert);
});

app.get('/api/vehicle/maintenance/:vehicleId', (req, res) => {
  const { vehicleId } = req.params;
  
  const maintenanceData = {
    vehicleId,
    nextService: {
      type: 'oil_change',
      dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
      milesDue: 75000,
      currentMiles: 73245
    },
    serviceHistory: [
      {
        date: '2024-10-15',
        type: 'oil_change',
        mileage: 70000,
        cost: 45.99
      },
      {
        date: '2024-08-20',
        type: 'tire_rotation',
        mileage: 68500,
        cost: 25.00
      }
    ],
    warrantyStatus: {
      powertrain: {
        expires: '2027-12-31',
        mileageLimit: 100000
      },
      basic: {
        expires: '2025-12-31',
        mileageLimit: 60000
      }
    }
  };
  
  res.json(maintenanceData);
});

app.listen(PORT, () => {
  console.log(`Vehicle Telemetry API running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`Metrics: http://localhost:${PORT}/metrics`);
});
