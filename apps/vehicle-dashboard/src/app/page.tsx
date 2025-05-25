'use client';

import { useState, useEffect } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

interface VehicleData {
  id: string;
  timestamp: string;
  speed: number;
  rpm: number;
  fuelLevel: number;
  engineTemp: number;
  location: {
    lat: number;
    lng: number;
  };
}

export default function Dashboard() {
  const [vehicleData, setVehicleData] = useState<VehicleData[]>([]);
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    // Simulate real-time data updates
    const interval = setInterval(() => {
      const newData: VehicleData = {
        id: Math.random().toString(36).substr(2, 9),
        timestamp: new Date().toISOString(),
        speed: Math.floor(Math.random() * 80) + 20,
        rpm: Math.floor(Math.random() * 3000) + 1000,
        fuelLevel: Math.floor(Math.random() * 100),
        engineTemp: Math.floor(Math.random() * 50) + 180,
        location: {
          lat: 42.3601 + (Math.random() - 0.5) * 0.1,
          lng: -71.0589 + (Math.random() - 0.5) * 0.1,
        },
      };

      setVehicleData(prev => [...prev.slice(-19), newData]);
      setIsConnected(true);
    }, 2000);

    return () => clearInterval(interval);
  }, []);

  const chartData = vehicleData.map((data, index) => ({
    time: index,
    speed: data.speed,
    rpm: data.rpm / 10, // Scale down for better visualization
    fuel: data.fuelLevel,
  }));

  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <div className="max-w-7xl mx-auto">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            example example Vehicle Telemetry Dashboard
          </h1>
          <div className="flex items-center space-x-4">
            <div className={`w-3 h-3 rounded-full ${isConnected ? 'bg-green-500' : 'bg-red-500'}`}></div>
            <span className="text-gray-600">
              {isConnected ? 'Connected to Event Hub' : 'Disconnected'}
            </span>
          </div>
        </div>

        {/* Current Vehicle Stats */}
        {vehicleData.length > 0 && (
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold text-gray-700 mb-2">Current Speed</h3>
              <div className="text-3xl font-bold text-blue-600">
                {vehicleData[vehicleData.length - 1]?.speed} mph
              </div>
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold text-gray-700 mb-2">Engine RPM</h3>
              <div className="text-3xl font-bold text-green-600">
                {vehicleData[vehicleData.length - 1]?.rpm}
              </div>
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold text-gray-700 mb-2">Fuel Level</h3>
              <div className="text-3xl font-bold text-yellow-600">
                {vehicleData[vehicleData.length - 1]?.fuelLevel}%
              </div>
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold text-gray-700 mb-2">Engine Temp</h3>
              <div className="text-3xl font-bold text-red-600">
                {vehicleData[vehicleData.length - 1]?.engineTemp}°F
              </div>
            </div>
          </div>
        )}

        {/* Real-time Chart */}
        <div className="bg-white p-6 rounded-lg shadow mb-8">
          <h2 className="text-2xl font-semibold text-gray-800 mb-4">Real-time Telemetry</h2>
          <ResponsiveContainer width="100%" height={400}>
            <LineChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="time" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Line type="monotone" dataKey="speed" stroke="#2563eb" name="Speed (mph)" />
              <Line type="monotone" dataKey="rpm" stroke="#16a34a" name="RPM (x10)" />
              <Line type="monotone" dataKey="fuel" stroke="#eab308" name="Fuel %" />
            </LineChart>
          </ResponsiveContainer>
        </div>

        {/* Recent Events */}
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-2xl font-semibold text-gray-800 mb-4">Recent Vehicle Events</h2>
          <div className="space-y-3">
            {vehicleData.slice(-5).reverse().map((data) => (
              <div key={data.id} className="border-l-4 border-blue-500 pl-4 py-2">
                <div className="flex justify-between items-center">
                  <span className="text-sm text-gray-600">
                    {new Date(data.timestamp).toLocaleTimeString()}
                  </span>
                  <span className="text-sm font-medium">
                    Speed: {data.speed} mph | RPM: {data.rpm} | Fuel: {data.fuelLevel}%
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
