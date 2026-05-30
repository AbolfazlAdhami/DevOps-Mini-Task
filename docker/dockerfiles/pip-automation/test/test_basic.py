from src.my_packages import hello


def test_hello():
    assert hello("world") == "Hello, world!"


def test_hello_returns_string():
    assert isinstance(hello("x"), str)
