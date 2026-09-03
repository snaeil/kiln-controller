{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.git ];

  # https://devenv.sh/languages/
  languages.python = {
      enable = true;
      uv = {
          enable = true;
          sync.enable = true;
      };
  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    formatter = {
      exec = "uv run black .";
      description = "Format code with Black";
    };
    typecheck = {
      exec = "uv run mypy .";
      description = "Type check with Mypy";
    };
    unit-tests = {
      exec = "ulimit -n 50000 && uv run pytest -v";
      description = "Run unit tests";
    };
    doc-tests = {
      exec = "ulimit -n 50000 && uv run pytest --doctest-modules";
      description = "Run doctests";
    };
    lint = {
      exec = "pylint **/*.py";
      description = "Lint source code";
    };
    test-coverage = {
      exec = "ulimit -n 50000 && uv run pytest --cov-report html --cov=. .";
      description = "Generate coverage report";
    };
    security = {
      exec = "uv audit";
      description = "Check for vulnerabilities";
    };
  };
  enterShell = ''
    source .devenv/state/venv/bin/activate
    echo
    echo "Helper scripts/tools you can run and that are (mostly) used by pre-commit:"
    echo
    ${pkgs.gnused}/bin/sed -e 's| |••|g' -e 's|=| |' <<EOF | ${pkgs.util-linuxMinimal}/bin/column -t | ${pkgs.gnused}/bin/sed -e 's|^|🦾 |' -e 's|••| |g'
    ${lib.generators.toKeyValue { } (lib.mapAttrs (name: value: value.description) config.scripts)}
    EOF
    echo
    uv pip install -e .
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    unit-tests = {
      enable = true;
      name = "Unit tests";
      entry = "unit-tests";
      types = [
        "python"
        "toml"
      ];
      language = "system";
      pass_filenames = false;
      always_run = true;
    };
    doc-tests = {
      enable = true;
      name = "Doctests";
      entry = "doc-tests";
      types = [
        "python"
        "toml"
      ];
      language = "system";
      pass_filenames = true;
    };
    lint = {
      enable = false;
      name = "Lint source code";
      entry = "lint";
      types = [
        "python"
        "toml"
      ];
      language = "system";
      pass_filenames = false;
      always_run = true;
    };
    typecheck = {
      enable = true;
      name = "Mypy";
      entry = "typecheck";
      types = [
        "python"
        "toml"
      ];
      language = "system";
      pass_filenames = false;
    };
    black = {
      enable = true;
      name = "Black";
      entry = "formatter";
      types = [ "python" ];
      language = "system";
      pass_filenames = true;
    };
    commitizen.enable = true;
    shellcheck.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
