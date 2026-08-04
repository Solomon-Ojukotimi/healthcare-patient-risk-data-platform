import os
from dotenv import load_dotenv

load_dotenv()

EVENTHUB_NAMESPACE = os.getenv("EVENTHUB_NAMESPACE")
EVENTHUB_NAME = os.getenv("EVENTHUB_NAME")
CONNECTION_STRING = os.getenv("EVENTHUB_CONNECTION_STRING")

FHIR_DIRECTORY = os.getenv("FHIR_DIRECTORY")
STREAM_DELAY = int(os.getenv("STREAM_DELAY", 1))