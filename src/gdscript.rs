use std::net::Ipv4Addr;

use zed::LanguageServerId;
use zed_extension_api::{
    self as zed, serde_json::Value, DebugAdapterBinary, DebugTaskDefinition, Result,
    StartDebuggingRequestArguments, StartDebuggingRequestArgumentsRequest, TcpArguments, Worktree,
};

struct GDScriptExtension;

impl zed::Extension for GDScriptExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let (os, _) = zed::current_platform();
        let nc_command = if os == zed::Os::Windows {
            worktree.which("ncat").or_else(|| worktree.which("nc"))
        } else {
            worktree.which("nc").or_else(|| worktree.which("ncat"))
        };

        let path = nc_command
            .ok_or_else(|| "nc or ncat must be installed and available on your PATH".to_string())?;

        let lsp_settings = zed::settings::LspSettings::for_worktree("gdscript", &worktree);
        let mut args = None;

        if let Ok(lsp_settings) = lsp_settings {
            if let Some(binary) = lsp_settings.binary {
                args = binary.arguments;
            }
        }

        Ok(zed::Command {
            command: path,
            args: args.unwrap_or(vec!["127.0.0.1".to_string(), "6005".to_string()]),
            env: Default::default(),
        })
    }

    fn get_dap_binary(
        &mut self,
        _adapter_name: String,
        config: DebugTaskDefinition,
        _user_provided_debug_adapter_path: Option<String>,
        _worktree: &Worktree,
    ) -> Result<DebugAdapterBinary, String> {
        Ok(DebugAdapterBinary {
            command: None,
            arguments: vec![],
            envs: Default::default(),
            cwd: None,

            // Godot only uses TCP for debugging
            connection: Some(TcpArguments {
                // TODO: api uses `u32` for host but official implementations are using `Ipv4Addr`
                // So we need to keep an eye on this
                host: Ipv4Addr::new(127, 0, 0, 1).to_bits(),
                port: 6006,
                timeout: None,
            }),

            request_args: StartDebuggingRequestArguments {
                configuration: config.config,
                request: StartDebuggingRequestArgumentsRequest::Launch,
            },
        })
    }

    fn dap_request_kind(
        &mut self,
        _adapter_name: String,
        _config: Value,
    ) -> Result<StartDebuggingRequestArgumentsRequest, String> {
        Ok(StartDebuggingRequestArgumentsRequest::Launch) // TODO: test if attach or launch
    }
}

zed::register_extension!(GDScriptExtension);
