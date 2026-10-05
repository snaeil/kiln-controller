import typer

app = typer.Typer()


@app.command()
def run():
    print(f"Running kiln-controller")


if __name__ == "__main__":
    app()


