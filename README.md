# Starknet Validator: Grafana Dashboards and Alerts

Two Grafana dashboards and one alert rule set for running a Starknet validator.

They visualise the Prometheus metrics exposed by the [eqlabs/starknet-validator-attestation](https://github.com/eqlabs/starknet-validator-attestation) tool and by the [pathfinder](https://github.com/eqlabs/pathfinder) node.

## What is here

| File | What it is |
| --- | --- |
| `starknet-attestation-dashboard.json` | Attestation dashboard: epochs, attestations, success rate, operational balance |
| `starknet-node-dashboard.json` | Node dashboard: sync health, gateway, block pipeline, RPC |
| `attestation-monitoring.yaml` | 22 Grafana-managed alert rules |

### Attestation dashboard

- Starknet latest block number
- Current epoch ID, epoch length, epoch progress
- Epoch start block and assigned block
- Blocks remaining until attestation
- Time since last successful attestation
- Success rate (%)
- Submitted, confirmed and failed attestations
- Missed epochs
- Operational account balance (STRK)

### Node dashboard

Top row answers "is anything wrong right now": node running, in sync, node stall in the last 24h, hung gateway submissions in the last 24h, restarts in the last 24h. Four collapsed rows below hold the detail: sync lag and block intake rate, gateway latency and failures by reason, block pipeline timing, and RPC calls from the attestation tool.

The stall lamp shows the clock time of the last stall rather than a word, so the moment can be found directly on the graphs below it.

## Setup

**1. Expose metrics.** Run the attestation tool with a metrics address, one instance per network:

```
--metrics-address 127.0.0.1:9095
--metrics-address 127.0.0.1:9096
```

Pathfinder exposes its own metrics; the node dashboard expects them on `9000` for mainnet and `9001` for testnet.

**2. Scrape them.** Add both jobs to `prometheus.yml`:

```yaml
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

- job_name: "pathfinder"
  static_configs:
    - targets: ['localhost:9000']
    - targets: ['localhost:9001']
```

The attestation dashboard and the alert rules select networks by `exported_network` (`SN_MAIN`, `SN_SEPOLIA`). The node dashboard uses pathfinder's own `network` label (`mainnet`, `testnet-sepolia`) — no relabelling needed for it.

**3. Restart Prometheus** and add it as a data source in Grafana.

**4. Import the dashboards.** Both files are in the Grafana v2 dashboard schema (`apiVersion: dashboard.grafana.app/v2`) and were exported from Grafana 13.2. Open the dashboard, then `?editview=json-model` → "Edit as code", paste the file, `Apply changes`, then `Save`. Applying alone only changes what is on screen; without `Save` the change is lost on reload.

**5. Import the alerts.** `attestation-monitoring.yaml` is a Grafana provisioning export, not a Prometheus rule file. The `Alerting → Import alert rules` page will not take it — that page accepts Prometheus-format rules only. Two paths that do work with this format: place the file in `/etc/grafana/provisioning/alerting/` and restart Grafana, which makes the rules read-only in the UI; or send it through the provisioning API with the `X-Disable-Provenance: true` header, which leaves them editable.

## Two things the alert file does not carry

**The contact point.** The rules reference it by name, `grafana-default-email`. The contact point itself, with the email address, lives elsewhere and is not part of the export — create it before importing, or the rules will have nowhere to deliver.

**The data source binding.** The rules point at a Prometheus data source by its internal UID. If your Prometheus has a different UID, the rules will import and stay silent. Replace the UID in the file before importing, or fix it afterwards in each rule.

## Alert rules

Nine rules per network, plus four shared ones.

Per network (`[Mainnet]` and `[Sepolia]`): attestation success rate below 99.5%, last attestation delay, attestation failures detected, attestation service down, operational account balance low, missed epoch detected, node lagging behind chain, pathfinder down, node stalled.

Shared: heartbeat, remote write behind, remote write failing, gateway submission hung.

The heartbeat rule fires permanently by design: it is the detector for a broken email path. If those emails stop arriving, alerting itself is broken, not the validator.
