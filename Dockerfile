# Use an official lightweight Python image.
FROM python:3.8-slim

# Set working directory
WORKDIR /app

# Copy dependency file and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the ML model code
COPY . .

# Command to run our app
CMD ["python", "model.py"]
