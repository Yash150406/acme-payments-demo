FROM python:3.9
# missing_logging — no USER directive (runs as root)
# missing_logging — no HEALTHCHECK
# missing_logging — unpinned base image
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python", "main.py"]
