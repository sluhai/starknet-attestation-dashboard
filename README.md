# Starknet Attestation Dashboard

This is a Grafana dashboard for monitoring Starknet validator attestations.

It visualizes the Prometheus metrics exposed by the [eqlabs/starknet-validator-attestation](https://github.com/eqlabs/starknet-validator-attestation) tool.

**Metrics displayed**

- Starknet latest block number
- Epoch progress (%)
- Blocks remaining until attestation
- Time since last successful attestation
- Success rate (%)
- Number of submitted, confirmed, and failed attestations (time series)

## Setup

To use this dashboard:
1. Make sure your validator attestation tool is running and exposing metrics on a port (e.g., http://localhost:9095/metrics).
2. Ensure Prometheus is scraping that endpoint.
3. Add Prometheus as a data source in Grafana.
4. Import the starknet-attestation-dashboard-v2.json file in your Grafana UI.
5. Select your desired network from the Network dropdown.

That's it.

<img width="1470" alt="image" src="https://github.com/user-attachments/assets/f3f8d4e3-0387-4bf9-a915-3afd9cf822b3" />


