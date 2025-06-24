resource "grafana_rule_group" "rule_group_4f7ad2fea5e182e5" {
  org_id           = 1
  name             = "attestation-monitoring"
  folder_uid       = "ceoxwir3zehogd"
  interval_seconds = 30

  rule {
    name      = "[Sepolia] Attestation Success Rate Below 100%"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 * (\\n  validator_attestation_attestation_confirmed_count{exported_network=\\\"SN_SEPOLIA\\\"}\\n  /\\n  validator_attestation_attestation_submitted_count{exported_network=\\\"SN_SEPOLIA\\\"}\\n)\\n\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[99.99],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "⚠️ Attestation success rate dropped below 100% on Sepolia. Check logs or metrics."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Sepolia] Last Attestation Delay"
    condition = "C"

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
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[33.33333333],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
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

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    annotations = {
      summary = "Last attestation happened over 33 minutes and 20 seconds ago on Sepolia.\nCheck if the attestation tool is running and synced."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
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
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(validator_attestation_attestation_failure_count{exported_network=\\\"SN_SEPOLIA\\\"}[1m])\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
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
      summary = "🚨 Attestation Failures Detected on Sepolia.\nValidator has submitted one or more failed attestations in the last minute."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
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
    annotations = {
      summary = "❌ Attestation Service DOWN\nThe validator-attestation service is not reachable on Sepolia.\nPlease check Docker container or system service status."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Attestation Success Rate Below 100%"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 60
        to   = 0
      }

      datasource_uid = "beo6ke2svn08wb"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 * (\\n  validator_attestation_attestation_confirmed_count{exported_network=\\\"SN_MAIN\\\"}\\n  /\\n  validator_attestation_attestation_submitted_count{exported_network=\\\"SN_MAIN\\\"}\\n)\\n\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[99.99],\"type\":\"lte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "30s"
    annotations = {
      summary = "⚠️ Attestation success rate dropped below 100% on MAINNET. Check logs or metrics."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
    }
    missing_series_evals_to_resolve = 1
  }
  rule {
    name      = "[Mainnet] Last Attestation Delay"
    condition = "C"

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
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[100],\"type\":\"gte\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
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

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    annotations = {
      summary = "Last attestation happened over 1 hour and 40 minutes ago on MAINNET.\nCheck if the attestation tool is running and synced."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
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
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(validator_attestation_attestation_failure_count{exported_network=\\\"SN_MAIN\\\"}[1m])\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
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
      summary = "🚨 Attestation Failures Detected on MAINNET.\nValidator has submitted one or more failed attestations in the last minute."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
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
    annotations = {
      summary = "❌ Attestation Service DOWN\nThe validator-attestation service is not reachable on MAINNET.\nPlease check Docker container or system service status."
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
    }
    missing_series_evals_to_resolve = 1
  }
}
