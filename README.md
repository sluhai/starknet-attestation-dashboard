# Starknet Validator Attestation Dashboard

This is a Grafana dashboard for monitoring Starknet validator attestations.

It visualizes the Prometheus metrics exposed by the [eqlabs/starknet-validator-attestation](https://github.com/eqlabs/starknet-validator-attestation) tool.

**Metrics displayed**

- Starknet latest block number
- Epoch progress (%)
- Blocks remaining until attestation
- Time since last successful attestation
- Success rate (%)
- Number of submitted, confirmed, and failed attestations (time series)
- Epoch Start Block
- Current Epoch ID
- Epoch Length
- Assigned Block

## Setup

To use this dashboard:
1. Make sure your validator attestation tool is running and exposing metrics on a port (e.g., http://localhost:9095/metrics).
2. Add a job to your prometheus.yml file so that Prometheus scrapes metrics from the corresponding port(s) of your attestation tool instance(s), for example:
```
- job_name: "starknet-attestation"
    static_configs:
      - targets: ['localhost:9095']
      - targets: ['localhost:9096']
    relabel_configs:
      - source_labels: [__address__]
        regex: localhost:9095
        target_label: exported_network
        replacement: SN_MAIN
      - source_labels: [__address__]
        regex: localhost:9096
        target_label: exported_network
        replacement: SN_SEPOLIA
  ```
3. After updating the configuration, restart Prometheus. It will begin collecting and storing metrics for visualization and analysis.
4. Add Prometheus as a data source in Grafana.
5. Import the starknet-attestation-dashboard.json file in your Grafana UI.

That's it.

<img width="1470" alt="image" src="https://github.com/user-attachments/assets/279c0520-ce58-4e02-a0a0-f1f1191edfbd" />









