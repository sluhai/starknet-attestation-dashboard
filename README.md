# Starknet validator dashboards and alerts

Grafana dashboards and alert rules for running a Starknet validator, built around the metrics exposed by
[eqlabs/starknet-validator-attestation](https://github.com/eqlabs/starknet-validator-attestation) and by the
[pathfinder](https://github.com/eqlabs/pathfinder) node behind it.

| File | What it is |
| --- | --- |
| `starknet-attestation-dashboard.json` | Attestation dashboard. Top row open, seven analysis rows collapsed. |
| `starknet-node-dashboard.json` | Pathfinder node health. Status row open, four rows collapsed. |
| `attestation-monitoring.yaml` | 22 alert rules, Grafana provisioning format. |

Both dashboards are in the Grafana 13 schema v2 format and use the Prometheus data source by its internal
identifier, so after importing you may need to repoint them at your own data source.

## Prometheus jobs

The dashboards expect two scrape jobs. The relabelling in the first one is what produces the
`exported_network` label the attestation dashboard filters on.

```yaml
- job_name: "starknet-attestation"
  static_configs:
    - targets: ['localhost:9095', 'localhost:9096']
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
    - targets: ['localhost:9000', 'localhost:9001']
```

Run the attestation tool with `--metrics-address 127.0.0.1:9095` for mainnet and `:9096` for testnet, and
pathfinder with `--monitor-address 0.0.0.0:9000`, mapped to host port 9000 for mainnet and 9001 for testnet.
Reload Prometheus after editing the configuration.

## Importing a dashboard

These are schema v2 files; the old import-by-paste path does not accept them. Open the dashboard, add
`?editview=json-model` to its address, follow `Take me there`, paste the file into `Edit as code`, then
`Apply changes` — **and then `Save`**. `Apply changes` only redraws the screen; without `Save` nothing is
written to the server.

## Importing the alert rules

The `Alerting → Import alert rules` page accepts Prometheus rule format only and will refuse this file. Use
one of these instead:

- drop the file into `/etc/grafana/provisioning/alerting/` and restart Grafana — the rules become
  provisioned and read-only in the interface;
- or POST it to the provisioning API with the header `X-Disable-Provenance: true` — the rules stay editable.

Two things the export does not carry, and without them the rules load but do not work:

- the contact point. The rules reference it by name (`grafana-default-email`); create it yourself.
- the data source identifier. If your Prometheus has a different one, every rule needs repointing.

## Notes on the node dashboard

Three panels use `rpc_websocket_connections`, `rpc_websocket_connections_closed_total` and
`rpc_websocket_connections_rejected_total`, which exist only in pathfinder 0.24.0 and newer. On older
versions they read `No data`; everything else works from 0.23 onwards.
