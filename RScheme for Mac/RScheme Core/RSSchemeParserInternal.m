//
//  RSSchemeParserInternal.m
//  RScheme for Mac
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

// This file is mainly adapted from Bootstrap Scheme by Peter Michaux.
// Below is the original copyright section.

/*
 * Bootstrap Scheme - a quick and very dirty Scheme interpreter.
 * Copyright (C) 2010 Peter Michaux (http://peter.michaux.ca/)
 *
 * This program is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public
 * License version 3 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License version 3 for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License version 3 along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 */

#import "RSSchemeParserInternal.h"

char is_the_empty_list(RSObject* obj)
{
    return obj == the_empty_list;
}

char is_boolean(RSObject* obj)
{
    return obj.type == BOOLEAN;
}

char is_false(RSObject* obj)
{
    return obj == false_value;
}

char is_true(RSObject* obj)
{
    return !is_false(obj);
}

RSObject* make_symbol(NSString* value)
{
    RSObject* obj;
    RSObject* element;

    /* search for they symbol in the symbol table */
    element = symbol_table;
    while (!is_the_empty_list(element)) {
        if ([car(element).data.symbol.value isEqualToString:value]) {
            return car(element);
        }
        element = cdr(element);
    };

    /* create the symbol and add it to the symbol table */
    obj = [RSObject new];
    obj.type = SYMBOL;
    obj.data.symbol = [RSString new];
    obj.data.symbol.value = [value copy];
    symbol_table = cons(obj, symbol_table);
    return obj;
}

char is_symbol(RSObject* obj)
{
    return obj.type == SYMBOL;
}

RSObject* make_fixnum(long value)
{
    RSObject* obj = [[RSObject alloc] init];
    obj.type = FIXNUM;
    obj.data.fixnum = [RSNumber init];
    obj.data.fixnum.value = value;
    return obj;
}

char is_fixnum(RSObject* obj)
{
    return obj.type == FIXNUM;
}

RSObject* make_character(char value)
{
    RSObject* obj = [[RSObject alloc] init];
    obj.type = CHARACTER;
    obj.data.character = [[RSString alloc] init];
    obj.data.character.value = [NSString stringWithFormat:@"%c", value];
    return obj;
}

char is_character(RSObject* obj)
{
    return obj.type == CHARACTER;
}

RSObject* make_string(NSString* value)
{
    RSObject* obj = [RSObject new];
    obj.type = STRING;
    obj.data.string = [RSString new];
    obj.data.string.value = [NSString stringWithFormat:@"%@", value];
    return obj;
}

char is_string(RSObject* obj)
{
    return obj.type == STRING;
}

RSObject* cons(RSObject* car, RSObject* cdr)
{
    RSObject* obj = [RSObject new];
    obj.type = PAIR;
    obj.data.pair = [RSPair new];
    obj.data.pair.car = car;
    obj.data.pair.cdr = cdr;
    return obj;
}

char is_pair(RSObject* obj)
{
    return obj.type == PAIR;
}

RSObject* car(RSObject* pair)
{
    return pair.data.pair.car;
}

void set_car(RSObject* obj, RSObject* value)
{
    obj.data.pair.car = value;
}

RSObject* cdr(RSObject* pair)
{
    return pair.data.pair.cdr;
}

void set_cdr(RSObject* obj, RSObject* value)
{
    obj.data.pair.cdr = value;
}

RSObject* make_primitive_proc(RSObject* (*fn)(RSObject* arguments))
{
    RSObject* obj;
    obj = [RSObject new];
    obj.type = PRIMITIVE_PROC;
    obj.data.primitive_proc = [RSPrimitiveProc new];
    obj.data.primitive_proc.fn = fn;
    return obj;
}

char is_primitive_proc(RSObject* obj)
{
    return obj.type == PRIMITIVE_PROC;
}

RSObject* is_null_proc(RSObject* arguments)
{
    return is_the_empty_list(car(arguments)) ? true_value : false_value;
}

RSObject* is_boolean_proc(RSObject* arguments)
{
    return is_boolean(car(arguments)) ? true_value : false_value;
}

RSObject* is_symbol_proc(RSObject* arguments)
{
    return is_symbol(car(arguments)) ? true_value : false_value;
}

RSObject* is_integer_proc(RSObject* arguments)
{
    return is_fixnum(car(arguments)) ? true_value : false_value;
}

RSObject* is_char_proc(RSObject* arguments)
{
    return is_character(car(arguments)) ? true_value : false_value;
}

RSObject* is_string_proc(RSObject* arguments)
{
    return is_string(car(arguments)) ? true_value : false_value;
}

RSObject* is_pair_proc(RSObject* arguments)
{
    return is_pair(car(arguments)) ? true_value : false_value;
}

char is_compound_proc(RSObject* obj);

RSObject* is_procedure_proc(RSObject* arguments)
{
    RSObject* obj;

    obj = car(arguments);
    return (is_primitive_proc(obj) || is_compound_proc(obj)) ? true_value : false_value;
}

//??? seems not right
RSObject* char_to_integer_proc(RSObject* arguments)
{
    return make_fixnum((car(arguments)).data.character.value.UTF8String[0]);
}

RSObject* integer_to_char_proc(RSObject* arguments)
{
    return make_character((car(arguments)).data.fixnum.value);
}

RSObject* number_to_string_proc(RSObject* arguments)
{
    return make_string([NSString stringWithFormat:@"%ld", (car(arguments)).data.fixnum.value]);
}

RSObject* string_to_number_proc(RSObject* arguments)
{
    return make_fixnum((car(arguments)).data.character.value.integerValue);
}

RSObject* symbol_to_string_proc(RSObject* arguments)
{
    return make_string((car(arguments)).data.symbol.value);
}

RSObject* string_to_symbol_proc(RSObject* arguments)
{
    return make_symbol((car(arguments)).data.string.value);
}

RSObject* add_proc(RSObject* arguments)
{
    long result = 0;

    while (!is_the_empty_list(arguments)) {
        result += (car(arguments)).data.fixnum.value;
        arguments = cdr(arguments);
    }
    return make_fixnum(result);
}

RSObject* sub_proc(RSObject* arguments)
{
    long result;

    result = (car(arguments)).data.fixnum.value;
    while (!is_the_empty_list(arguments = cdr(arguments))) {
        result -= (car(arguments)).data.fixnum.value;
    }
    return make_fixnum(result);
}

RSObject* mul_proc(RSObject* arguments)
{
    long result = 1;

    while (!is_the_empty_list(arguments)) {
        result *= (car(arguments)).data.fixnum.value;
        arguments = cdr(arguments);
    }
    return make_fixnum(result);
}

RSObject* quotient_proc(RSObject* arguments)
{
    return make_fixnum(
        ((car(arguments)).data.fixnum.value) / ((cadr(arguments)).data.fixnum.value));
}

RSObject* remainder_proc(RSObject* arguments)
{
    return make_fixnum(
        ((car(arguments)).data.fixnum.value) % ((cadr(arguments)).data.fixnum.value));
}

RSObject* is_number_equal_proc(RSObject* arguments)
{
    long value;

    value = (car(arguments)).data.fixnum.value;
    while (!is_the_empty_list(arguments = cdr(arguments))) {
        if (value != ((car(arguments)).data.fixnum.value)) {
            return false_value;
        }
    }
    return true_value;
}

RSObject* is_less_than_proc(RSObject* arguments)
{
    long previous;
    long next;

    previous = (car(arguments)).data.fixnum.value;
    while (!is_the_empty_list(arguments = cdr(arguments))) {
        next = (car(arguments)).data.fixnum.value;
        if (previous < next) {
            previous = next;
        }
        else {
            return false_value;
        }
    }
    return true_value;
}

RSObject* is_greater_than_proc(RSObject* arguments)
{
    long previous;
    long next;

    previous = (car(arguments)).data.fixnum.value;
    while (!is_the_empty_list(arguments = cdr(arguments))) {
        next = (car(arguments)).data.fixnum.value;
        if (previous > next) {
            previous = next;
        }
        else {
            return false_value;
        }
    }
    return true_value;
}

RSObject* cons_proc(RSObject* arguments)
{
    return cons(car(arguments), cadr(arguments));
}

RSObject* car_proc(RSObject* arguments)
{
    return caar(arguments);
}

RSObject* cdr_proc(RSObject* arguments)
{
    return cdar(arguments);
}

RSObject* set_car_proc(RSObject* arguments)
{
    set_car(car(arguments), cadr(arguments));
    return ok_symbol;
}

RSObject* set_cdr_proc(RSObject* arguments)
{
    set_cdr(car(arguments), cadr(arguments));
    return ok_symbol;
}

RSObject* list_proc(RSObject* arguments)
{
    return arguments;
}

RSObject* is_eq_proc(RSObject* arguments)
{
    RSObject* obj1;
    RSObject* obj2;

    obj1 = car(arguments);
    obj2 = cadr(arguments);

    if (obj1.type != obj2.type) {
        return false_value;
    }
    switch (obj1.type) {
    case FIXNUM:
        return (obj1.data.fixnum.value == obj2.data.fixnum.value) ? true_value : false_value;
        break;
    case CHARACTER:
        return (obj1.data.character.value == obj2.data.character.value) ? true_value : false_value;
        break;
    case STRING:
        return ([obj1.data.string.value isEqualToString:obj2.data.string.value]) ? true_value : false_value;
        break;
    default:
        return (obj1 == obj2) ? true_value : false_value;
    }
}

RSObject* apply_proc(RSObject* arguments)
{
    NSLog(@"illegal state: The body of the apply primitive procedure should not execute.\n");
    exit(1);
}

RSObject* interaction_environment_proc(RSObject* arguments)
{
    return the_global_environment;
}

RSObject* null_environment_proc(RSObject* arguments)
{
    return setup_environment();
}

RSObject* environment_proc(RSObject* arguments)
{
    return make_environment();
}

RSObject* eval_proc(RSObject* arguments)
{
    NSLog(@"illegal state: The body of the eval primitive procedure should not execute.\n");
    exit(1);
}

//TODO: Change FILE or NSFileHandle to NSMutableString
RSObject* load_proc(RSObject* arguments)
{
    NSString* filename;
    NSFileHandle* in;
    RSObject* exp;
    RSObject* result;

    filename = car(arguments).data.string.value;
    in = [NSFileHandle fileHandleForReadingAtPath:filename];
    if (in == nil) {
        NSLog(@"could not load file \"%@\"", filename);
        exit(1);
    }
    while ((exp = _read(in)) != NULL) {
        result = eval(exp, the_global_environment);
    }
    return result;
}

//TODO: Change FILE or NSFileHandle to NSMutableString
RSObject* write_proc(RSObject* arguments)
{
    RSObject* exp;
    NSFileHandle* out;

    exp = car(arguments);
    arguments = cdr(arguments);
    //    out = is_the_empty_list(arguments) ?
    //    stdout :
    //    car(arguments)->data.output_port.stream;
    //FIXME: only stdout supported!
    out = [NSFileHandle fileHandleWithStandardOutput];
    _write(out, exp);
    return ok_symbol;
}

//TODO: Change FILE or NSFileHandle to NSMutableString
RSObject* error_proc(RSObject* arguments)
{
    while (!is_the_empty_list(arguments)) {
        NSFileHandle* stderr = [NSFileHandle fileHandleWithStandardError];
        _write(stderr, car(arguments));
        arguments = cdr(arguments);
    };
    printf("\nexiting\n");
    exit(1);
}

RSObject* make_compound_proc(RSObject* parameters, RSObject* body,
                             RSObject* env)
{
    RSObject* obj;

    obj = [RSObject new];
    obj.type = COMPOUND_PROC;
    obj.data.compound_proc = [RSCompoundProc new];
    obj.data.compound_proc.parameters = parameters;
    obj.data.compound_proc.body = body;
    obj.data.compound_proc.env = env;
    return obj;
}

char is_compound_proc(RSObject* obj)
{
    return obj.type == COMPOUND_PROC;
}

RSObject* make_input_port(FILE* stream);

char is_input_port(RSObject* obj);

RSObject* make_output_port(FILE* stream);

char is_output_port(RSObject* obj);

char is_eof_RSObject(RSObject* obj);

RSObject* enclosing_environment(RSObject* env)
{
    return cdr(env);
}

RSObject* first_frame(RSObject* env)
{
    return car(env);
}

RSObject* make_frame(RSObject* variables, RSObject* values)
{
    return cons(variables, values);
}

RSObject* frame_variables(RSObject* frame)
{
    return car(frame);
}

RSObject* frame_values(RSObject* frame)
{
    return cdr(frame);
}

void add_binding_to_frame(RSObject* var, RSObject* val,
                          RSObject* frame)
{
    set_car(frame, cons(var, car(frame)));
    set_cdr(frame, cons(val, cdr(frame)));
}

RSObject* extend_environment(RSObject* vars, RSObject* vals,
                             RSObject* base_env)
{
    return cons(make_frame(vars, vals), base_env);
}

RSObject* lookup_variable_value(RSObject* var, RSObject* env)
{
    RSObject* frame;
    RSObject* vars;
    RSObject* vals;
    while (!is_the_empty_list(env)) {
        frame = first_frame(env);
        vars = frame_variables(frame);
        vals = frame_values(frame);
        while (!is_the_empty_list(vars)) {
            if (var == car(vars)) {
                return car(vals);
            }
            vars = cdr(vars);
            vals = cdr(vals);
        }
        env = enclosing_environment(env);
    }
    fprintf(stderr, "%s", [[NSString stringWithFormat:@"unbound variable, %@\n", var.data.symbol.value] UTF8String]);
    exit(1);
}

void set_variable_value(RSObject* var, RSObject* val, RSObject* env)
{
    RSObject* frame;
    RSObject* vars;
    RSObject* vals;

    while (!is_the_empty_list(env)) {
        frame = first_frame(env);
        vars = frame_variables(frame);
        vals = frame_values(frame);
        while (!is_the_empty_list(vars)) {
            if (var == car(vars)) {
                set_car(vals, val);
                return;
            }
            vars = cdr(vars);
            vals = cdr(vals);
        }
        env = enclosing_environment(env);
    }
    fprintf(stderr, "%s", [[NSString stringWithFormat:@"unbound variable, %@\n", var.data.symbol.value] UTF8String]);
    exit(1);
}

void define_variable(RSObject* var, RSObject* val, RSObject* env)
{
    RSObject* frame;
    RSObject* vars;
    RSObject* vals;

    frame = first_frame(env);
    vars = frame_variables(frame);
    vals = frame_values(frame);

    while (!is_the_empty_list(vars)) {
        if (var == car(vars)) {
            set_car(vals, val);
            return;
        }
        vars = cdr(vars);
        vals = cdr(vals);
    }
    add_binding_to_frame(var, val, frame);
}

RSObject* setup_environment(void)
{
    RSObject* initial_env;

    initial_env = extend_environment(
        the_empty_list,
        the_empty_list,
        the_empty_environment);
    return initial_env;
}

void populate_environment(RSObject* env)
{

#define add_procedure(scheme_name, c_name)       \
    define_variable(make_symbol(scheme_name),    \
                    make_primitive_proc(c_name), \
                    env);

    add_procedure(@"null?", is_null_proc);
    add_procedure(@"boolean?", is_boolean_proc);
    add_procedure(@"symbol?", is_symbol_proc);
    add_procedure(@"integer?", is_integer_proc);
    add_procedure(@"char?", is_char_proc);
    add_procedure(@"string?", is_string_proc);
    add_procedure(@"pair?", is_pair_proc);
    add_procedure(@"procedure?", is_procedure_proc);

    add_procedure(@"char.integer", char_to_integer_proc);
    add_procedure(@"integer.char", integer_to_char_proc);
    add_procedure(@"number.string", number_to_string_proc);
    add_procedure(@"string.number", string_to_number_proc);
    add_procedure(@"symbol.string", symbol_to_string_proc);
    add_procedure(@"string.symbol", string_to_symbol_proc);

    add_procedure(@"+", add_proc);
    add_procedure(@"-", sub_proc);
    add_procedure(@"*", mul_proc);
    add_procedure(@"quotient", quotient_proc);
    add_procedure(@"remainder", remainder_proc);
    add_procedure(@"=", is_number_equal_proc);
    add_procedure(@"<", is_less_than_proc);
    add_procedure(@">", is_greater_than_proc);

    add_procedure(@"cons", cons_proc);
    add_procedure(@"car", car_proc);
    add_procedure(@"cdr", cdr_proc);
    add_procedure(@"set-car!", set_car_proc);
    add_procedure(@"set-cdr!", set_cdr_proc);
    add_procedure(@"list", list_proc);

    add_procedure(@"eq?", is_eq_proc);

    add_procedure(@"apply", apply_proc);

    add_procedure(@"interaction-environment",
                  interaction_environment_proc);
    add_procedure(@"null-environment", null_environment_proc);
    add_procedure(@"environment", environment_proc);
    add_procedure(@"eval", eval_proc);

    //    add_procedure(@"load", load_proc);
    //    add_procedure(@"open-input-port", open_input_port_proc);
    //    add_procedure(@"close-input-port", close_input_port_proc);
    //    add_procedure(@"input-port?", is_input_port_proc);
    //    add_procedure(@"read", read_proc);
    //    add_procedure(@"read-char", read_char_proc);
    //    add_procedure(@"peek-char", peek_char_proc);
    //    add_procedure(@"eof-RSObject?", is_eof_RSObject_proc);
    //    add_procedure(@"open-output-port", open_output_port_proc);
    //    add_procedure(@"close-output-port", close_output_port_proc);
    //    add_procedure(@"output-port?", is_output_port_proc);
    //    add_procedure(@"write-char", write_char_proc);
    //    add_procedure(@"write", write_proc);

    add_procedure(@"error", error_proc);
}

RSObject* make_environment(void)
{
    RSObject* env;

    env = setup_environment();
    populate_environment(env);
    return env;
}

void init(void)
{
    the_empty_list = [RSObject new];
    the_empty_list.type = THE_EMPTY_LIST;

    false_value = [RSObject new];
    false_value.type = BOOLEAN;
    false_value.data.boolean = [RSNumber new];
    false_value.data.boolean.value = 0;

    true_value = [RSObject new];
    true_value.type = BOOLEAN;
    true_value.data.boolean = [RSNumber new];
    true_value.data.boolean.value = 1;

    symbol_table = the_empty_list;
    quote_symbol = make_symbol(@"quote");
    define_symbol = make_symbol(@"define");
    set_symbol = make_symbol(@"set!");
    ok_symbol = make_symbol(@"ok");
    if_symbol = make_symbol(@"if");
    lambda_symbol = make_symbol(@"lambda");
    begin_symbol = make_symbol(@"begin");
    cond_symbol = make_symbol(@"cond");
    else_symbol = make_symbol(@"else");
    let_symbol = make_symbol(@"let");
    and_symbol = make_symbol(@"and");
    or_symbol = make_symbol(@"or");

    //    eof_RSObject = [RSObject new];
    //    eof_RSObject.type = EOF_OBJECT;

    the_empty_environment = the_empty_list;

    the_global_environment = make_environment();
}

/***************************** READ ******************************/

char is_delimiter(int c)
{
    return isspace(c) || c == EOF || c == '(' || c == ')' || c == '"' || c == ';';
}

char is_initial(int c)
{
    return isalpha(c) || c == '*' || c == '/' || c == '>' || c == '<' || c == '=' || c == '?' || c == '!';
}

int peek(FILE* in)
{
    int c;

    c = getc(in);
    ungetc(c, in);
    return c;
}

//TODO: Change FILE or NSFileHandle to NSMutableString
void eat_whitespace(NSFileHandle* in)
{
    int c;

    while ((c = [in getc]) != EOF) {
        if (isspace(c)) {
            continue;
        }
        else if (c == ';') { // comments are whitespace alse
            while (((c = [in getc]) != EOF) && (c != '\n'))
                ;
            continue;
        }
        [in ungetc:c];
        break;
    }
}

void eat_expected_string(FILE* in, char* str)
{
    int c;

    while (*str != '\0') {
        c = getc(in);
        if (c != *str) {
            fprintf(stderr, "unexpected character '%c'\n", c);
            exit(1);
        }
        str++;
    }
}

void peek_expected_delimiter(FILE* in)
{
    if (!is_delimiter(peek(in))) {
        fprintf(stderr, "character not followed by delimiter\n");
        exit(1);
    }
}

//TODO: Change FILE or NSFileHandle to NSMutableString
RSObject* read_character(FILE* in)
{
    int c;

    c = getc(in);
    switch (c) {
    case EOF:
        fprintf(stderr, "incomplete character literal\n");
        exit(1);
    case 's':
        if (peek(in) == 'p') {
            eat_expected_string(in, "pace");
            peek_expected_delimiter(in);
            return make_character(' ');
        }
        break;
    case 'n':
        if (peek(in) == 'e') {
            eat_expected_string(in, "ewline");
            peek_expected_delimiter(in);
            return make_character('\n');
        }
        break;
    }
    peek_expected_delimiter(in);
    return make_character(c);
}

//TODO: Change FILE or NSFileHandle to NSMutableString
RSObject* read_pair(NSFileHandle* in)
{
    int c;
    RSObject* car_obj;
    RSObject* cdr_obj;

    //[in eatWhiteSpace];
    eat_whitespace(in);

    c = [in getc];
    if (c == ')') { //read the empty list
        return the_empty_list;
    }
    [in ungetc:c];

    car_obj = _read(in);

    //[in eatWhiteSpace];
    eat_whitespace(in);

    c = [in getc];
    if (c == '.') { // read improper list
        c = [in peek];
        if (!is_delimiter(c)) {
            fprintf(stderr, "dot not followed by delimiter\n");
            exit(1);
        }
        car_obj = _read(in);
        //[in eatWhiteSpace];
        eat_whitespace(in);
        c = [in getc];
        if (c != ')') {
            fprintf(stderr, "where was the trailing right paren?\n");
            exit(1);
        }
        return cons(car_obj, cdr_obj);
    }
    else { // read list
        [in ungetc:c];
        cdr_obj = read_pair(in);
        return cons(car_obj, cdr_obj);
    }
}

//TODO: Change FILE or NSFileHandle to NSMutableString
RSObject* _read(NSFileHandle* in)
{
    int c;
    short sign = 1;
    int i;
    long num = 0;

#define BUFFER_MAX 1000
    NSMutableString* buffer = [[NSMutableString alloc] init];

    //[in eatWhiteSpace];
    eat_whitespace(in);

    c = [in getc];

    if (c == '#') { // read a boolean or character
        c = [in getc];
        switch (c) {
        case 't':
            return true_value;
        case 'f':
            return false_value;
        case '\\':
            //TODO: implemented read_character function in objective c style
            //return read_character((__bridge FILE *)(in));
            return THE_EMPTY_LIST;
        default:
            fprintf(stderr,
                    "unknown boolean or character literal\n");
            exit(1);
        }
    }
    else if (isdigit(c) || (c == '-' && isdigit([in peek]))) {
        if (c == '-') {
            sign = -1;
        }
        else {
            [in ungetc:c];
        }
        while (isdigit(c = [in getc])) {
            num = (num * 10) + (c - '0');
        }
        num *= sign;
        if (is_delimiter(c)) {
            [in ungetc:c];
            return make_fixnum(num);
        }
        else {
            fprintf(stderr, "number not followed by delimiter\n");
            exit(1);
        }
    }
    else if (is_initial(c) || ((c == '+' || c == '-') && is_delimiter([in peek]))) { // read a symbol
        i = 0;
        while (is_initial(c) || isdigit(c) || c == '+' || c == '-') {
            // sub 1 to save space for '\0' // is it neccessary?
            if (i < BUFFER_MAX - 1) {
                [buffer appendFormat:@"%c", c];
                i++;
            }
            else {
                fprintf(stderr, "symbol too long. "
                                "Maximum length is %d\n",
                        BUFFER_MAX);
                exit(1);
            }
            c = [in getc];
        }
        if (is_delimiter(c)) {
            [in ungetc:c];
            return make_symbol([buffer copy]);
        }
        else {
            fprintf(stderr, "symbol not followed by delimiter. "
                            "Found %c\n",
                    c);
            exit(1);
        }
    }
    else if (c == '"') { // read a string
        i = 0;
        while ((c = [in getc]) != '"') {
            if (c == '\\') {
                c = [in getc];
                if (c == 'n') {
                    c = '\n';
                }
            }
            if (c == EOF) {
                fprintf(stderr, "non-terminated string literal\n");
                exit(1);
            }
            // sub 1 to save space for '\0'
            if (i < BUFFER_MAX - 1) {
                [buffer appendFormat:@"%c", c];
                i++;
            }
            else {
                fprintf(stderr, "symbol too long. "
                                "Maximum length is %d\n",
                        BUFFER_MAX);
                exit(1);
            }
        }
        return make_string([buffer copy]);
    }
    else if (c == '(') { // read the empty list or pair
        return read_pair(in);
    }
    else if (c == '\'') { // read quoted expression
        return cons(quote_symbol, cons(_read(in), the_empty_list));
    }
    else if (c == EOF) {
        return NULL;
    }
    else {
        fprintf(stderr, "bad input. Unexpected '%c'\n", c);
        exit(1);
    }
    fprintf(stderr, "read illegal state\n");
    exit(1);
}

char is_self_evaluating(RSObject* exp)
{
    return is_boolean(exp) || is_fixnum(exp) || is_character(exp) || is_string(exp);
}

char is_variable(RSObject* expression)
{
    return is_symbol(expression);
}

char is_tagged_list(RSObject* expression, RSObject* tag)
{
    RSObject* the_car;

    if (is_pair(expression)) {
        the_car = car(expression);
        return is_symbol(the_car) && (the_car == tag);
    }
    return 0;
}

char is_quoted(RSObject* expression)
{
    return is_tagged_list(expression, quote_symbol);
}

RSObject* text_of_quotation(RSObject* exp)
{
    return cadr(exp);
}

char is_assignment(RSObject* exp)
{
    return is_tagged_list(exp, set_symbol);
}

RSObject* assignment_variable(RSObject* exp)
{
    return car(cdr(exp));
}

RSObject* assignment_value(RSObject* exp)
{
    return car(cdr(cdr(exp)));
}

char is_definition(RSObject* exp)
{
    return is_tagged_list(exp, define_symbol);
}

RSObject* definition_variable(RSObject* exp)
{
    if (is_symbol(cadr(exp))) {
        return cadr(exp);
    }
    else {
        return caadr(exp);
    }
}

RSObject* make_lambda(RSObject* parameters, RSObject* body);

RSObject* definition_value(RSObject* exp)
{
    if (is_symbol(cadr(exp))) {
        return caddr(exp);
    }
    else {
        return make_lambda(cdadr(exp), cddr(exp));
    }
}

RSObject* make_if(RSObject* predicate, RSObject* consequent,
                  RSObject* alternative)
{
    return cons(if_symbol,
                cons(predicate,
                     cons(consequent,
                          cons(alternative, the_empty_list))));
}

char is_if(RSObject* expression)
{
    return is_tagged_list(expression, if_symbol);
}

RSObject* if_predicate(RSObject* exp)
{
    return cadr(exp);
}

RSObject* if_consequent(RSObject* exp)
{
    return caddr(exp);
}

RSObject* if_alternative(RSObject* exp)
{
    if (is_the_empty_list(cdddr(exp))) {
        return false;
    }
    else {
        return cadddr(exp);
    }
}

RSObject* make_lambda(RSObject* parameters, RSObject* body)
{
    return cons(lambda_symbol, cons(parameters, body));
}

char is_lambda(RSObject* exp)
{
    return is_tagged_list(exp, lambda_symbol);
}

RSObject* lambda_parameters(RSObject* exp)
{
    return cadr(exp);
}

RSObject* lambda_body(RSObject* exp)
{
    return cddr(exp);
}

RSObject* make_begin(RSObject* seq)
{
    return cons(begin_symbol, seq);
}

char is_begin(RSObject* exp)
{
    return is_tagged_list(exp, begin_symbol);
}

RSObject* begin_actions(RSObject* exp)
{
    return cdr(exp);
}

char is_last_exp(RSObject* seq)
{
    return is_the_empty_list(cdr(seq));
}

RSObject* first_exp(RSObject* seq)
{
    return car(seq);
}

RSObject* rest_exps(RSObject* seq)
{
    return cdr(seq);
}

char is_cond(RSObject* exp)
{
    return is_tagged_list(exp, cond_symbol);
}

RSObject* cond_clauses(RSObject* exp)
{
    return cdr(exp);
}

RSObject* cond_predicate(RSObject* clause)
{
    return car(clause);
}

RSObject* cond_actions(RSObject* clause)
{
    return cdr(clause);
}

char is_cond_else_clause(RSObject* clause)
{
    return cond_predicate(clause) == else_symbol;
}

RSObject* sequence_to_exp(RSObject* seq)
{
    if (is_the_empty_list(seq)) {
        return seq;
    }
    else if (is_last_exp(seq)) {
        return first_exp(seq);
    }
    else {
        return make_begin(seq);
    }
}

RSObject* expand_clauses(RSObject* clauses)
{
    RSObject* first;
    RSObject* rest;

    if (is_the_empty_list(clauses)) {
        return false;
    }
    else {
        first = car(clauses);
        rest = cdr(clauses);
        if (is_cond_else_clause(first)) {
            if (is_the_empty_list(rest)) {
                return sequence_to_exp(cond_actions(first));
            }
            else {
                fprintf(stderr, "else clause isn't last cond.if");
                exit(1);
            }
        }
        else {
            return make_if(cond_predicate(first),
                           sequence_to_exp(cond_actions(first)),
                           expand_clauses(rest));
        }
    }
}

RSObject* cond_to_if(RSObject* exp)
{
    return expand_clauses(cond_clauses(exp));
}

RSObject* make_application(RSObject* operator, RSObject* operands)
{
    return cons(operator, operands);
}

char is_application(RSObject* exp)
{
    return is_pair(exp);
}

RSObject* operator(RSObject* exp)
{
    return car(exp);
}

RSObject* operands(RSObject* exp)
{
    return cdr(exp);
}

char is_no_operands(RSObject* ops)
{
    return is_the_empty_list(ops);
}

RSObject* first_operand(RSObject* ops)
{
    return car(ops);
}

RSObject* rest_operands(RSObject* ops)
{
    return cdr(ops);
}

char is_let(RSObject* exp)
{
    return is_tagged_list(exp, let_symbol);
}

RSObject* let_bindings(RSObject* exp)
{
    return cadr(exp);
}

RSObject* let_body(RSObject* exp)
{
    return cddr(exp);
}

RSObject* binding_parameter(RSObject* binding)
{
    return car(binding);
}

RSObject* binding_argument(RSObject* binding)
{
    return cadr(binding);
}

RSObject* bindings_parameters(RSObject* bindings)
{
    return is_the_empty_list(bindings) ? the_empty_list : cons(binding_parameter(car(bindings)),
                                                               bindings_parameters(cdr(bindings)));
}

RSObject* bindings_arguments(RSObject* bindings)
{
    return is_the_empty_list(bindings) ? the_empty_list : cons(binding_argument(car(bindings)),
                                                               bindings_arguments(cdr(bindings)));
}

RSObject* let_parameters(RSObject* exp)
{
    return bindings_parameters(let_bindings(exp));
}

RSObject* let_arguments(RSObject* exp)
{
    return bindings_arguments(let_bindings(exp));
}

RSObject* let_to_application(RSObject* exp)
{
    return make_application(
        make_lambda(let_parameters(exp),
                    let_body(exp)),
        let_arguments(exp));
}

char is_and(RSObject* exp)
{
    return is_tagged_list(exp, and_symbol);
}

RSObject* and_tests(RSObject* exp)
{
    return cdr(exp);
}

char is_or(RSObject* exp)
{
    return is_tagged_list(exp, or_symbol);
}

RSObject* or_tests(RSObject* exp)
{
    return cdr(exp);
}

RSObject* apply_operator(RSObject* arguments)
{
    return car(arguments);
}

RSObject* prepare_apply_operands(RSObject* arguments)
{
    if (is_the_empty_list(cdr(arguments))) {
        return car(arguments);
    }
    else {
        return cons(car(arguments),
                    prepare_apply_operands(cdr(arguments)));
    }
}

RSObject* apply_operands(RSObject* arguments)
{
    return prepare_apply_operands(cdr(arguments));
}

RSObject* eval_expression(RSObject* arguments)
{
    return car(arguments);
}

RSObject* eval_environment(RSObject* arguments)
{
    return cadr(arguments);
}

RSObject* list_of_values(RSObject* exps, RSObject* env)
{
    if (is_no_operands(exps)) {
        return the_empty_list;
    }
    else {
        return cons(eval(first_operand(exps), env),
                    list_of_values(rest_operands(exps), env));
    }
}

RSObject* eval_assignment(RSObject* exp, RSObject* env)
{
    set_variable_value(assignment_variable(exp),
                       eval(assignment_value(exp), env),
                       env);
    return ok_symbol;
}

RSObject* eval_definition(RSObject* exp, RSObject* env)
{
    define_variable(definition_variable(exp),
                    eval(definition_value(exp), env),
                    env);
    return ok_symbol;
}

RSObject* eval(RSObject* exp, RSObject* env)
{
    RSObject* procedure;
    RSObject* arguments;
    RSObject* result;

tailcall:
    if (is_self_evaluating(exp)) {
        return exp;
    }
    else if (is_variable(exp)) {
        return lookup_variable_value(exp, env);
    }
    else if (is_quoted(exp)) {
        return text_of_quotation(exp);
    }
    else if (is_assignment(exp)) {
        return eval_assignment(exp, env);
    }
    else if (is_definition(exp)) {
        return eval_definition(exp, env);
    }
    else if (is_if(exp)) {
        exp = is_true(eval(if_predicate(exp), env)) ? if_consequent(exp) : if_alternative(exp);
        goto tailcall;
    }
    else if (is_lambda(exp)) {
        return make_compound_proc(lambda_parameters(exp),
                                  lambda_body(exp),
                                  env);
    }
    else if (is_begin(exp)) {
        exp = begin_actions(exp);
        while (!is_last_exp(exp)) {
            eval(first_exp(exp), env);
            exp = rest_exps(exp);
        }
        exp = first_exp(exp);
        goto tailcall;
    }
    else if (is_cond(exp)) {
        exp = cond_to_if(exp);
        goto tailcall;
    }
    else if (is_let(exp)) {
        exp = let_to_application(exp);
        goto tailcall;
    }
    else if (is_and(exp)) {
        exp = and_tests(exp);
        if (is_the_empty_list(exp)) {
            return true_value;
        }
        while (!is_last_exp(exp)) {
            result = eval(first_exp(exp), env);
            if (is_false(result)) {
                return result;
            }
            exp = rest_exps(exp);
        }
        exp = first_exp(exp);
        goto tailcall;
    }
    else if (is_or(exp)) {
        exp = or_tests(exp);
        if (is_the_empty_list(exp)) {
            return false;
        }
        while (!is_last_exp(exp)) {
            result = eval(first_exp(exp), env);
            if (is_true(result)) {
                return result;
            }
            exp = rest_exps(exp);
        }
        exp = first_exp(exp);
        goto tailcall;
    }
    else if (is_application(exp)) {
        procedure = eval(operator(exp), env);
        arguments = list_of_values(operands(exp), env);

        /* handle eval specially for tail call requirement */
        if (is_primitive_proc(procedure) && procedure.data.primitive_proc.fn == eval_proc) {
            exp = eval_expression(arguments);
            env = eval_environment(arguments);
            goto tailcall;
        }

        /* handle apply specially for tail call requirement */
        if (is_primitive_proc(procedure) && procedure.data.primitive_proc.fn == apply_proc) {
            procedure = apply_operator(arguments);
            arguments = apply_operands(arguments);
        }

        if (is_primitive_proc(procedure)) {
            return (procedure.data.primitive_proc.fn)(arguments);
        }
        else if (is_compound_proc(procedure)) {
            env = extend_environment(
                procedure.data.compound_proc.parameters,
                arguments,
                procedure.data.compound_proc.env);
            exp = make_begin(procedure.data.compound_proc.body);
            goto tailcall;
        }
        else {
            fprintf(stderr, "unknown procedure type\n");
            exit(1);
        }
    }
    else {
        fprintf(stderr, "cannot eval unknown expression type\n");
        exit(1);
    }
    fprintf(stderr, "eval illegal state\n");
    exit(1);
}

//TODO: Change FILE or NSFileHandle to NSMutableString
void write_pair(NSFileHandle* out, RSObject* pair)
{
    RSObject* car_obj = car(pair);
    RSObject* cdr_obj = cdr(pair);

    _write(out, car_obj);
    if (cdr_obj.type == PAIR) {
        //[out writeData:[NSData dataWithBytes:" " length:1]];
        [out printString:@" "];
        write_pair(out, cdr_obj);
    }
    else if (cdr_obj.type == THE_EMPTY_LIST) {
        return;
    }
    else {
        //[out writeData:[NSData dataWithBytes:"." length:1]];
        [out printString:@"."];
        _write(out, cdr_obj);
    }
}

//TODO: Change FILE or NSFileHandle to NSMutableString
void _write(NSFileHandle* out, RSObject* obj)
{
    char c;
    NSString* str = [[NSString alloc] init];

    switch (obj.type) {
    case THE_EMPTY_LIST:
        [out printString:@"()"];
        break;
    case BOOLEAN:
        [out printString:[NSString stringWithFormat:@"#%c", is_false(obj) ? 'f' : 't']];
        break;
    case SYMBOL:
        [out printString:obj.data.symbol.value];
        break;
    case FIXNUM:
        [out printString:[NSString stringWithFormat:@"%ld", obj.data.fixnum.value]];
        break;
    case CHARACTER:
        c = [obj.data.character.value characterAtIndex:0];
        [out printString:@"#\\"];
        switch (c) {
        case '\n':
            [out printString:@"newline"];
            break;
        case ' ':
            [out printString:@"space"];
            break;
        default:
            [out printString:[NSString stringWithFormat:@"%c", c]];
        }
        break;
    case STRING:
        str = obj.data.string.value;
        [out printString:[NSString stringWithFormat:@"%c", '"']];
        for (int i = 0; i < str.length; i++) {
            switch (c = [str characterAtIndex:i]) {
            case '\n':
                [out printString:@"\n"];
                break;
            case '\\':
                [out printString:@"\\\\"];
                break;
            case '"':
                [out printString:@"\\\""];
                break;
            default:
                [out printString:[NSString stringWithFormat:@"%c", c]];
                break;
            }
        }
        [out printString:[NSString stringWithFormat:@"%c", '"']];
        break;
    case PAIR:
        [out printString:@"("];
        write_pair(out, obj);
        [out printString:@")"];
        break;
    case PRIMITIVE_PROC:
        [out printString:@"#<primitive-procedure>"];
        break;
    case COMPOUND_PROC:
        [out printString:@"#<compound-procedure>"];
        break;
    default:
        fprintf(stderr, "cannot write unknown type\n");
        exit(1);
    }
}

@implementation RSNumber

@end

@implementation RSPair

@end

@implementation RSString

@end

@implementation RSPrimitiveProc

@end

@implementation RSCompoundProc

@end

@implementation RSInternalData

@end

@implementation RSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [RSInternalData new];
    }
    return self;
}

@end
