import typer

app = typer.Typer()


@app.command()
def run():
    """
    [green]Start up[/green] the kiln controller. :runner:
    """
    import kiln_controller.app.kiln_controller


if __name__ == "__main__":
    app()
