combinations=[(True,True, True),(True,True,False),(True,False,True),(True,False, False),(False,True, True),(False,True, False),(False, False,True),(False,False, False)]#expand this set for more variables
variable={'p':0,'q':1, 'r':2}

kb=''
q=''
priority={'~':3,'v':1,'^':2}

def rules():
    global kb,q
    kb=(input("Enter the rule="))
    q=input("Enter the query=")
    
    
def entailment():
    print('kb','alpha')
    print("\n")
    for cb in combinations:
        s=postfixEvaluate(toPostfix(kb),cb)
        f=postfixEvaluate(toPostfix(q),cb)
        print(s,f)
        print("\n")
        if s and not f:
            return False
    return True


def _eval(i,val1,val2):
    if i=='^':
        return val2 and val1
    return val2 or val1


def postfixEvaluate(exp,comb):
    stack = []
    for i in exp:
        if isOperand(i):
            stack.append(comb[variable[i]])
        elif i == '~':
            val1 = stack.pop()
            stack.append(not val1)
        else:
            val1 = stack.pop()
            val2 = stack.pop()
            stack.append(_eval(i,val1,val2))

    return stack.pop()

def toPostfix(infix):
    stack=[]
    postfix = ''
    for c in infix:
        if isOperand(c):
            postfix += c
        else:
            if isLeftParanthesis(c):
                stack.append(c)
            elif isRightParanthesis(c):
                operator = stack.pop()
                while not isLeftParanthesis(operator):
                    postfix += operator
                    operator = stack.pop()
            else:
                while (not isEmpty(stack)) and hasLessOrEqualPriority(c,peek(stack)):
                    postfix += stack.pop()
                stack.append(c)
    while (not isEmpty(stack)):
        postfix += stack.pop()
    return postfix



def isOperand(c):
    return c.isalpha() and c!= 'v'

def isLeftParanthesis(c):
    return c=='('

def isRightParanthesis(c):
    return c==')'

def isEmpty(stack):
    return len(stack)==0

def peek(stack):
    return stack[-1]

def hasLessOrEqualPriority(c1,c2):
    try: return priority[c1]<=priority[c2]
    except KeyError: return False

rules()
ans = entailment()
if ans:
    print("Knowledge base entails query")
else:
    print("Knowledge base does not entail query")