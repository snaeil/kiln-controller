import typer

from kiln_controller.cli import controller, logger, test, tuner

app = typer.Typer()
app.add_typer(controller.app, name="controller", help="Use the kiln controller.")
# app.add_typer(logger.app, name="logger")
# app.add_typer(tuner.app, name="tuner")
app.add_typer(test.app, name="test", help="Test local hardware and environment.")


if __name__ == "__main__":
    app()
