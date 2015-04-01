def factoriall(n, l=0):
    
    """

    :param n:
    :param l: 
    :return: 
    """
    i = 0
    y = 1
    if not n:
        return 1
    else:
        while i < (l if l else n):
            y *= n - i
            i += 1
    return y


def combinatorial(n, k):
    """

    :param n:
    :param k:
    :return:
    """
    x = n - k
    y = 1
    if n < k or n < 0 or k < 0:
        return 0
    elif n == k:
        return 1
    elif (n - k) == 1:
        return n
    else:
        y = factoriall(n, x)
        y /= factoriall(n - k)

    return y


def type_operator(x, value, operator):
    """

    :param x:
    :param valor:
    :param operator:
    :return:
    """

    if operator == '*':
        x *= value
    elif operator == '/':
        try:
            x /= value
        except ZeroDivisionError:
            print("Error: Valor is zero")
            exit(-1)
    elif operator == '+':
        x += value
    elif operator == '-':
        x -= value
    return x