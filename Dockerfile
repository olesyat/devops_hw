# First Stage
FROM python:3.7-slim AS builder

# Create a working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy all
COPY . .

# Second Stage
FROM python:3.7-slim

# Create a working directory
WORKDIR /app

# Add group and user to run a container
RUN groupadd -r webservice && useradd --no-log-init -r -g webservice webservice

# Copy installed dependencies from the build stage
COPY --from=builder /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages

# Copy application code from the build stage
COPY --from=builder /app .

USER webservice:webservice

# Expose port for ui
EXPOSE 8050

ENTRYPOINT ["python", "GraphAnalysis.py"]
CMD ["obj_dependency_data.csv"]
