import os
import json
import time

from kafka import KafkaProducer

from config import (
    EVENTHUB_NAMESPACE,
    EVENTHUB_NAME,
    CONNECTION_STRING,
    FHIR_DIRECTORY,
    STREAM_DELAY
)

READMISSION_CLINICAL_RESOURCES = {
    "Patient",
    "Encounter",
    "Condition",
    "MedicationRequest",
    "Procedure",
    "Observation"
}


def create_producer():
    """Create an Azure Event Hub Kafka producer."""

    return KafkaProducer(
        bootstrap_servers=[f"{EVENTHUB_NAMESPACE}:9093"],
        security_protocol="SASL_SSL",
        sasl_mechanism="PLAIN",
        sasl_plain_username="$ConnectionString",
        sasl_plain_password=CONNECTION_STRING,
        value_serializer=lambda value: json.dumps(value).encode("utf-8")
    )


def stream_fhir_data():

    producer = create_producer()

    print("==========================================")
    print(" Healthcare FHIR Streaming Started")
    print("==========================================")

    if not os.path.exists(FHIR_DIRECTORY):
        raise FileNotFoundError(
            f"FHIR directory not found: {FHIR_DIRECTORY}"
        )

    try:

        while True:

            for file_number, filename in enumerate(os.listdir(FHIR_DIRECTORY), start=1):

                if not filename.endswith(".json"):
                    continue

                file_path = os.path.join(FHIR_DIRECTORY, filename)

                try:

                    with open(file_path, encoding="utf-8") as file:

                        bundle = json.load(file)

                except json.JSONDecodeError:

                    print(f"Skipping invalid JSON: {filename}")

                    continue

                for entry in bundle.get("entry", []):

                    resource = entry.get("resource")

                    if not resource:

                        continue

                    resource_type = resource.get("resourceType")

                    if resource_type not in READMISSION_CLINICAL_RESOURCES:

                        continue

                    producer.send(EVENTHUB_NAME, resource)

                    producer.flush()

                    print(
                        f"[{file_number}] "
                        f"{resource_type:<20}"
                        f"{resource.get('id')}"
                    )

                    time.sleep(STREAM_DELAY)

            print("\nRestarting streaming simulation...\n")

    except KeyboardInterrupt:

        print("\nStreaming stopped.")

    finally:

        producer.close()


if __name__ == "__main__":

    stream_fhir_data()