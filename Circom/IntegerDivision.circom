pragma circom 2.1.4;

template IntegerDivide(nbits) {
    signal input dividend;
    signal input divisor;
    signal output quotient;
    signal output remainder;

    assert(nbits<=126);

    //Main division calc and constraint
    quotient <-- dividend \ divisor;
    remainder <-- divided % divisor;

    //Check correct division
    dividend === divisor*quotient + remainder;

}

component main = IntegerDivide(5);

/* INPUT = {
    "dividend": "250",
    "divisor":"27"
} */