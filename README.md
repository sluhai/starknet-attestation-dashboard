# Starknet Attestation Dashboard

This is a Grafana dashboard for monitoring Starknet validator attestations.

It visualizes the Prometheus metrics exposed by the [eqlabs/starknet-validator-attestation](https://github.com/eqlabs/starknet-validator-attestation) tool.

## The following metrics are displayed:

**Starknet latest block number**

**Current epoch information:**

- Epoch ID
- Epoch starting block number
- Epoch assigned block number
- Epoch length
- Epoch progress (%)
- Blocks remaining until attestation

**Attestation performance:**

- Number of submitted, confirmed, and failed attestations (time series)
- Success rate (%)
- Minutes since last successful attestation

**Validator service status**

**Network selector (SN_MAIN, SN_SEPOLIA, etc.)**

## Setup

To use this dashboard:
1. Make sure your validator attestation tool is running and exposing metrics on a port (e.g., http://localhost:9095/metrics).
2. Ensure Prometheus is scraping that endpoint.
3. Add Prometheus as a data source in Grafana.
4. Import the starknet-attestation-dashboard-v2.json file in your Grafana UI.
5. Select your desired network from the Network dropdown.

That's it.

<img width="1470" alt="image" src="https://github.com/user-attachments/assets/87bcc698-7f3b-477e-ae69-f456848564e6" />

