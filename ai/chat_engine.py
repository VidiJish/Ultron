from ai.brain.arithmetic import solve_expression
from ai.brain.logic import evaluate_logic
from ai.brain.creativity import generate_idea
from ai.brain.sanitation import sanitation_tips

def generate_response(user_input):
    for module in (
        solve_expression,
        evaluate_logic,
        generate_idea,
        sanitation_tips,
    ):
        reply = module(user_input)
        if reply:
            return reply
    return "Can you explain that a bit more?"
