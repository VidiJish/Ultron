import re

def solve_expression(text):
    try:
        expr = re.findall(r"[0-9+\-*/(). ]+", text)
        if not expr:
            return None
        result = eval(expr[0], {"__builtins__": {}})
        return f"The answer is {result}"
    except Exception:
        return None
