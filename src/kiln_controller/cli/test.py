import typer

app = typer.Typer()


@app.command()
def gpio():
    """
    Test your [green]gpio output[/green] to control a relay. :test_tube:
    """
    print(f"Running test")


if __name__ == "__main__":
    app()
