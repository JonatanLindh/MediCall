{ pkgs, ... }:

{
  languages = {
    python = {
      enable = true;
      venv.enable = true;

      uv = {
        enable = true;
        sync.enable = true;
      };
    };
  };

  packages = with pkgs; [
    openssl
  ];

  env = {
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
  };

  tasks = {
    # Create uv.lock if it doesn't exist
    "bash:uv-lock" = {
      description = "Lock virtual environment";
      exec = "uv lock";
      before = [ "devenv:python:uv" ];
      status = "test -f uv.lock";
    };
  };
}
