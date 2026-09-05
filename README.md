# Starknet validator dashboards and alerts

Grafana dashboards and alert rules for running a Starknet validator, built around the metrics exposed by
[eqlabs/starknet-validator-attestation](https://github.com/eqlabs/starknet-validator-attestation) and by the
[pathfinder](https://github.com/eqlabs/pathfinder) node behind it.

| File | What it is |
| --- | --- |
| `starknet-attestation-dashboard.json` | Attestation dashboard. Top row open, seven analysis rows collapsed. |
| `starknet-node-dashboard.json` | Pathfinder node health. Status row open, four rows collapsed. |
| `attestation-monitoring.yaml` | 22 alert rules, Grafana provisioning format. |

Both dashboards are in the Grafana 13 schema v2 format.

## Data source

Neither dashboard hardcodes a data source. Each one carries a `Data source` selector at the top, and every
panel reads its Prometheus from there, so nothing has to be edited panel by panel. On load Grafana picks a
Prometheus data source for you; if you have more than one, check the selector and switch it. The choice is
kept in the address of the page, so a link you copy carries it with you.

## The Network selector

Both dashboards carry a `Network` selector with three fixed choices: `Mainnet`, `Sepolia`, `Both`, and
`Both` is the default. Each choice is a regular expression that matches every spelling of the network at
once, because the metrics do not agree on one:

- the attestation tool labels its series `exported_network`, with `SN_MAIN` and `SN_SEPOLIA`;
- pathfinder labels its series `network`, with `mainnet` and `testnet-sepolia`;
- `up` and `process_start_time_seconds` carry no network label at all, and the network is only visible as
  the scrape port inside `instance`, `:9000` for mainnet and `:9001` for testnet.

So `Sepolia` holds `SN_SEPOLIA|testnet-sepolia` in the attestation dashboard and
`testnet-sepolia|.*9001` in the node dashboard. Regular expression matches in PromQL are anchored at both
ends, so the branches that do not belong to a given label simply never match. Two panels are deliberately
outside this: `SN_MAIN Attestations` and `SN_SEPOLIA Attestations` are each pinned to one network by
design, and empty when the other one is selected.

If you run a third network, add a line to the selector by hand — it is a custom variable and does not query
Prometheus.

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

The same editor is two clicks away without touching the address: in edit mode, open the toolbar on the
right edge of the dashboard and click the `{}` icon.

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

The panel `Websocket closes and rejects, last 24h` is not filtered by the `Network` selector. Both counters
come into existence at the first close and the first refusal, so their label set cannot be checked in
advance, and filtering on a label that may not be there would hide the rare event the panel exists for.

## Notes on the attestation dashboard

The `Long-term trends` row holds `Success rate, 7 days`, `Success rate, 30 days`, `Success rate, 90 days`
and `Missed epochs, 90 days`. They need that much history in Prometheus to mean what their names say.
On a store that keeps less — Grafana Cloud on the free plan keeps 14 days — the two long success rates
still compute a correct ratio, but over the history that exists rather than over the window in the title,
and `Missed epochs, 90 days` undercounts. Delete them, or read them knowing that.
