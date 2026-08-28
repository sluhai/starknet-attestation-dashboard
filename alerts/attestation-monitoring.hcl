resource "grafana_rule_group" "rule_group_4f7ad2fea5e182e5" {
  org_id           = 1
  name             = "attestation-monitoring"
  folder_uid       = "ceoxwir3zehogd"
  interval_seconds = 30

  rule {
    name      = "[Sepolia] Attestation Success Rate Below 99.5%"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 * (\\n  increase(validator_attestation_attestation_confirmed_count{exported_network=\\\"SN_SEPOLIA\\\"}[24h])\\n  /\\n  increase(validator_attestation_attestation_submitted_count{exported_network=\\\"SN_SEPOLIA\\\"}[24h])\\n)\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[99.5],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "⚠️ Attestation success rate dropped below 99.5% over the last 24h on SEPOLIA (two or more failed attestations). Check logs or metrics."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Sepolia] Last Attestation Delay"
    condition = "E"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(time() - clamp_min(validator_attestation_last_attestation_timestamp_seconds{exported_network=\\\"SN_SEPOLIA\\\"}, 1)) / 60\\n\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"datasource\":{\"type\":\"prometheus\",\"uid\":\"beo6ke2svn08wb\"},\"editorMode\":\"code\",\"expr\":\"validator_attestation_last_attestation_timestamp_seconds{exported_network=\\\"SN_SEPOLIA\\\"}\\n\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"B\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[15],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }
    data {
      ref_id = "D"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[1,0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"D\",\"type\":\"threshold\"}"
    }
    data {
      ref_id = "E"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0,0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"$C && $D\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"E\",\"type\":\"math\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    annotations = {
      summary = "Last attestation happened over 15 minutes ago on Sepolia.\nCheck if the attestation tool is running and synced."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Sepolia] Attestation Failures Detected"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(validator_attestation_attestation_failure_count{exported_network=\\\"SN_SEPOLIA\\\"}[24h])\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0.01],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    annotations = {
      summary = "🚨 Attestation Failures Detected on Sepolia.\nValidator has submitted one or more failed attestations in the last 24 hours."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Sepolia] Attestation Service Down"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"up{job=\\\"starknet-attestation\\\", exported_network=\\\"SN_SEPOLIA\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0.5],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "❌ Attestation Service DOWN\nThe validator-attestation service is not reachable on Sepolia.\nPlease check Docker container or system service status."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Attestation Success Rate Below 99.5%"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 * (\\n  increase(validator_attestation_attestation_confirmed_count{exported_network=\\\"SN_MAIN\\\"}[24h])\\n  /\\n  increase(validator_attestation_attestation_submitted_count{exported_network=\\\"SN_MAIN\\\"}[24h])\\n)\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[99.5],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "⚠️ Attestation success rate dropped below 99.5% over the last 24h on MAINNET (at least one failed attestation). Check logs or metrics."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Last Attestation Delay"
    condition = "E"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(time() - clamp_min(validator_attestation_last_attestation_timestamp_seconds{exported_network=\\\"SN_MAIN\\\"}, 1)) / 60\\n\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"datasource\":{\"type\":\"prometheus\",\"uid\":\"beo6ke2svn08wb\"},\"editorMode\":\"code\",\"expr\":\"validator_attestation_last_attestation_timestamp_seconds{exported_network=\\\"SN_MAIN\\\"}\\n\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"B\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[110],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }
    data {
      ref_id = "D"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[1,0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"D\",\"type\":\"threshold\"}"
    }
    data {
      ref_id = "E"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0,0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"$C && $D\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"E\",\"type\":\"math\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    annotations = {
      summary = "Last attestation happened over 1 hour and 50 minutes ago on MAINNET.\nCheck if the attestation tool is running and synced."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Attestation Failures Detected"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(validator_attestation_attestation_failure_count{exported_network=\\\"SN_MAIN\\\"}[24h])\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0.01],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    annotations = {
      summary = "🚨 Attestation Failures Detected on MAINNET.\nValidator has submitted one or more failed attestations in the last 24 hours."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Attestation Service Down"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"up{job=\\\"starknet-attestation\\\", exported_network=\\\"SN_MAIN\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0.5],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "❌ Attestation Service DOWN\nThe validator-attestation service is not reachable on MAINNET.\nPlease check Docker container or system service status."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Operational Account Balance Low"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"validator_attestation_operational_account_balance_strk{exported_network=\\\"SN_MAIN\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[500],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "Operational account balance is below 500 STRK on MAINNET. Top it up to avoid failed attestations."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Sepolia] Operational Account Balance Low"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"validator_attestation_operational_account_balance_strk{exported_network=\\\"SN_SEPOLIA\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[20000],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "Operational account balance is below 20000 STRK on SEPOLIA. Top it up to avoid failed attestations."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Missed Epoch Detected"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(validator_attestation_missed_epochs_count{exported_network=\\\"SN_MAIN\\\"}[24h])\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "An epoch was missed with no successful attestation on MAINNET. Check the node and the attestation service."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Sepolia] Missed Epoch Detected"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(validator_attestation_missed_epochs_count{exported_network=\\\"SN_SEPOLIA\\\"}[24h])\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "An epoch was missed with no successful attestation on SEPOLIA. Check the node and the attestation service."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Node Lagging Behind Chain"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"highest_block{network=\\\"mainnet\\\"} - current_block{network=\\\"mainnet\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[5],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "Pathfinder is more than 5 blocks behind the chain head on MAINNET. Attestations may fail."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Sepolia] Node Lagging Behind Chain"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"highest_block{network=\\\"testnet-sepolia\\\"} - current_block{network=\\\"testnet-sepolia\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[5],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "Pathfinder is more than 5 blocks behind the chain head on SEPOLIA. Attestations may fail."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "Heartbeat"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"vector(1)\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    annotations = {
      summary = "Grafana alerting heartbeat from nc-ph-3562. This rule fires permanently by design. If these emails stop arriving, the alert email path itself is broken."
    }
    is_paused = false

    notification_settings {
      contact_point   = "grafana-default-email"
      repeat_interval = "1h"
    }
  }
  rule {
    name      = "[Mainnet] Pathfinder Down"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"   up{job=\\\"pathfinder\\\", instance=\\\"localhost:9000\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id     = "C"
      query_type = "expression"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[1],\"type\":\"lt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "Pathfinder is not reachable on MAINNET (localhost:9000). Prometheus cannot scrape the node. Attestations will start failing if this continues."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
  }
  rule {
    name      = "[Sepolia] Pathfinder Down"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"   up{job=\\\"pathfinder\\\", instance=\\\"localhost:9001\\\"}\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id     = "C"
      query_type = "expression"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[1],\"type\":\"lt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "Pathfinder is not reachable on SEPOLIA (localhost:9001). Prometheus cannot scrape the node. Attestations will start failing if this continues."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
  }
  rule {
    name      = "Remote Write Behind"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"   (\\n     max_over_time(prometheus_remote_storage_highest_timestamp_in_seconds[5m])\\n   - ignoring(remote_name, url) group_right\\n     max_over_time(prometheus_remote_storage_queue_highest_sent_timestamp_seconds[5m])\\n   )\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id     = "C"
      query_type = "expression"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[60],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "Remote write to Grafana Cloud is more than 60 seconds behind. The cloud mirror is incomplete; local Prometheus and all local alerts are unaffected. Likely causes: the 10K active series limit, throttling, or the endpoint being unreachable."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
  }
  rule {
    name      = "Remote Write Failing"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"   increase(prometheus_remote_storage_samples_failed_total[10m])\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id     = "C"
      query_type = "expression"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "1m"
    annotations = {
      summary = "Prometheus is permanently failing to write samples to Grafana Cloud. These samples are lost, not retried. Likely causes: an invalid or revoked token, or data rejected by the endpoint. Local Prometheus and all local alerts are unaffected."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
    }
  }
}
