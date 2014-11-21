//
//  RSSchemeParserInternal.h
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
 * This program is distributed input the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License version 3 for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License version 3 along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 */

#import <Cocoa/Cocoa.h>
#import "NSFileHandle+withGetc.h"

@class RSObject;

@interface RSNumber : NSObject
@property long value;
@end

@interface RSPair : NSObject
@property RSObject* car;
@property RSObject* cdr;
@end

@interface RSString : NSObject
@property NSString* value;
@end

@interface RSPrimitiveProc : NSObject
@property RSObject* (*fn)(RSObject* arguments);
@end

@interface RSCompoundProc : NSObject
@property RSObject* parameters;
@property RSObject* body;
@property RSObject* env;
@end

@interface RSInternalData : NSObject
@property RSNumber* boolean;
@property RSString* symbol;
@property RSNumber* fixnum;
@property RSString* character;
@property RSString* string;
@property RSPair* pair;
@property RSPrimitiveProc* primitive_proc;
@property RSCompoundProc* compound_proc;
@end

typedef enum : NSUInteger {
                   THE_EMPTY_LIST,
                   BOOLEAN,
                   SYMBOL,
                   FIXNUM,
                   CHARACTER,
                   STRING,
                   PAIR,
                   PRIMITIVE_PROC,
                   COMPOUND_PROC,
               } RSObjectType;

@interface RSObject : NSObject
- (instancetype)init;
@property RSInternalData* data;
@property RSObjectType type;

@end

RSObject* the_empty_list;
RSObject* false_value;
RSObject* true_value;
RSObject* symbol_table;
RSObject* quote_symbol;
RSObject* define_symbol;
RSObject* set_symbol;
RSObject* ok_symbol;
RSObject* if_symbol;
RSObject* lambda_symbol;
RSObject* begin_symbol;
RSObject* cond_symbol;
RSObject* else_symbol;
RSObject* let_symbol;
RSObject* and_symbol;
RSObject* or_symbol;
RSObject* eof_RSObject;
RSObject* the_empty_environment;
RSObject* the_global_environment;

RSObject* cons(RSObject* car, RSObject* cdr);
RSObject* car(RSObject* pair);
RSObject* cdr(RSObject* pair);

char is_the_empty_list(RSObject* obj);

char is_boolean(RSObject* obj);

char is_false(RSObject* obj);

char is_true(RSObject* obj);

RSObject* make_symbol(NSString* value);

char is_symbol(RSObject* obj);

RSObject* make_fixnum(long value);

char is_fixnum(RSObject* obj);

RSObject* make_character(char value);

char is_character(RSObject* obj);

RSObject* make_string(NSString* value);

char is_string(RSObject* obj);

RSObject* cons(RSObject* car, RSObject* cdr);

char is_pair(RSObject* obj);

RSObject* car(RSObject* pair);

void set_car(RSObject* obj, RSObject* value);

RSObject* cdr(RSObject* pair);

void set_cdr(RSObject* obj, RSObject* value);

#define caar(obj) car(car(obj))
#define cadr(obj) car(cdr(obj))
#define cdar(obj) cdr(car(obj))
#define cddr(obj) cdr(cdr(obj))
#define caaar(obj) car(car(car(obj)))
#define caadr(obj) car(car(cdr(obj)))
#define cadar(obj) car(cdr(car(obj)))
#define caddr(obj) car(cdr(cdr(obj)))
#define cdaar(obj) cdr(car(car(obj)))
#define cdadr(obj) cdr(car(cdr(obj)))
#define cddar(obj) cdr(cdr(car(obj)))
#define cdddr(obj) cdr(cdr(cdr(obj)))
#define caaaar(obj) car(car(car(car(obj))))
#define caaadr(obj) car(car(car(cdr(obj))))
#define caadar(obj) car(car(cdr(car(obj))))
#define caaddr(obj) car(car(cdr(cdr(obj))))
#define cadaar(obj) car(cdr(car(car(obj))))
#define cadadr(obj) car(cdr(car(cdr(obj))))
#define caddar(obj) car(cdr(cdr(car(obj))))
#define cadddr(obj) car(cdr(cdr(cdr(obj))))
#define cdaaar(obj) cdr(car(car(car(obj))))
#define cdaadr(obj) cdr(car(car(cdr(obj))))
#define cdadar(obj) cdr(car(cdr(car(obj))))
#define cdaddr(obj) cdr(car(cdr(cdr(obj))))
#define cddaar(obj) cdr(cdr(car(car(obj))))
#define cddadr(obj) cdr(cdr(car(cdr(obj))))
#define cdddar(obj) cdr(cdr(cdr(car(obj))))
#define cddddr(obj) cdr(cdr(cdr(cdr(obj))))

RSObject* make_primitive_proc(RSObject* (*fn)(RSObject* arguments));

char is_primitive_proc(RSObject* obj);

RSObject* is_null_proc(RSObject* arguments);

RSObject* is_boolean_proc(RSObject* arguments);

RSObject* is_symbol_proc(RSObject* arguments);

RSObject* is_integer_proc(RSObject* arguments);

RSObject* is_char_proc(RSObject* arguments);

RSObject* is_string_proc(RSObject* arguments);

RSObject* is_pair_proc(RSObject* arguments);

char is_compound_proc(RSObject* obj);

RSObject* is_procedure_proc(RSObject* arguments);

//??? seems not right
RSObject* char_to_integer_proc(RSObject* arguments);

RSObject* integer_to_char_proc(RSObject* arguments);

RSObject* number_to_string_proc(RSObject* arguments);

RSObject* string_to_number_proc(RSObject* arguments);

RSObject* symbol_to_string_proc(RSObject* arguments);

RSObject* string_to_symbol_proc(RSObject* arguments);

RSObject* add_proc(RSObject* arguments);

RSObject* sub_proc(RSObject* arguments);

RSObject* mul_proc(RSObject* arguments);

RSObject* quotient_proc(RSObject* arguments);

RSObject* remainder_proc(RSObject* arguments);

RSObject* is_number_equal_proc(RSObject* arguments);

RSObject* is_less_than_proc(RSObject* arguments);

RSObject* is_greater_than_proc(RSObject* arguments);

RSObject* cons_proc(RSObject* arguments);

RSObject* car_proc(RSObject* arguments);

RSObject* cdr_proc(RSObject* arguments);

RSObject* set_car_proc(RSObject* arguments);

RSObject* set_cdr_proc(RSObject* arguments);

RSObject* list_proc(RSObject* arguments);

RSObject* is_eq_proc(RSObject* arguments);

RSObject* apply_proc(RSObject* arguments);

RSObject* interaction_environment_proc(RSObject* arguments);

RSObject* setup_environment(void);

RSObject* null_environment_proc(RSObject* arguments);

RSObject* make_environment(void);

RSObject* environment_proc(RSObject* arguments);

RSObject* eval_proc(RSObject* arguments);

RSObject* _read(NSMutableString* input);
RSObject* eval(RSObject* exp, RSObject* env);

RSObject* load_proc(RSObject* arguments);

RSObject* make_input_port(FILE* input);

//TODO: implement this function
//RSObject* open_input_port_proc(RSObject* arguments);
//
//RSObject* close_input_port_proc(RSObject* arguments);

//char is_input_port(RSObject* obj);

//RSObject* is_input_port_proc(RSObject* arguments)
//{
//    return is_input_port(car(arguments)) ? true_value : false_value;
//}

RSObject* read_proc(RSObject* arguments);

RSObject* read_char_proc(RSObject* arguments);

int peek(NSMutableString* input);

RSObject* peek_char_proc(RSObject* arguments);

char is_eof_RSObject(RSObject* obj);

//RSObject* is_eof_RSObject_proc(RSObject* arguments)
//{
//    return is_eof_RSObject(car(arguments)) ? true_value : false_value;
//}

//RSObject* make_output_port(FILE* input);
//
//RSObject* open_output_port_proc(RSObject* arguments);
//
//RSObject* close_output_port_proc(RSObject* arguments);
//
//char is_output_port(RSObject* obj);
//
//RSObject* is_output_port_proc(RSObject* arguments)
//{
//    return is_output_port(car(arguments)) ? true_value : false_value;
//}

//RSObject* write_char_proc(RSObject* arguments);

void _write(NSMutableString* out, RSObject* obj);

RSObject* write_proc(RSObject* arguments);

RSObject* error_proc(RSObject* arguments);

RSObject* make_compound_proc(RSObject* parameters, RSObject* body,
                             RSObject* env);

char is_compound_proc(RSObject* obj);

RSObject* make_input_port(FILE* stream);

char is_input_port(RSObject* obj);

RSObject* make_output_port(FILE* stream);

char is_output_port(RSObject* obj);

char is_eof_RSObject(RSObject* obj);

RSObject* enclosing_environment(RSObject* env);

RSObject* first_frame(RSObject* env);

RSObject* make_frame(RSObject* variables, RSObject* values);

RSObject* frame_variables(RSObject* frame);

RSObject* frame_values(RSObject* frame);

void add_binding_to_frame(RSObject* var, RSObject* val,
                          RSObject* frame);

RSObject* extend_environment(RSObject* vars, RSObject* vals,
                             RSObject* base_env);

RSObject* lookup_variable_value(RSObject* var, RSObject* env);

void set_variable_value(RSObject* var, RSObject* val, RSObject* env);

void define_variable(RSObject* var, RSObject* val, RSObject* env);

RSObject* setup_environment(void);

void populate_environment(RSObject* env);

RSObject* make_environment(void);

void init(NSMutableString* output);

/***************************** READ ******************************/

char is_delimiter(unichar c);

char is_initial(unichar c);

int peek(NSMutableString* input);

//void eat_whitespace(FILE* input)
//{
//    int c;
//
//    while ((c = getc(input)) != EOF) {
//        if (isspace(c)) {
//            continue;
//        }
//        else if (c == ';') { /* comments are whitespace also */
//            while (((c = getc(input)) != EOF) && (c != '\n'))
//                ;
//            continue;
//        }
//        ungetc(c, input);
//        break;
//    }
//}

void eat_whitespace(NSMutableString* input);

void eat_expected_string(NSMutableString* input, NSString* str);

void peek_expected_delimiter(NSMutableString* input);

RSObject* read_character(NSMutableString* input);

RSObject* read_pair(NSMutableString* input);

RSObject* _read(NSMutableString* input);

char is_self_evaluating(RSObject* exp);

char is_variable(RSObject* expression);

char is_tagged_list(RSObject* expression, RSObject* tag);

char is_quoted(RSObject* expression);

RSObject* text_of_quotation(RSObject* exp);

char is_assignment(RSObject* exp);

RSObject* assignment_variable(RSObject* exp);

RSObject* assignment_value(RSObject* exp);

char is_definition(RSObject* exp);

RSObject* definition_variable(RSObject* exp);

RSObject* make_lambda(RSObject* parameters, RSObject* body);

RSObject* definition_value(RSObject* exp);

RSObject* make_if(RSObject* predicate, RSObject* consequent,
                  RSObject* alternative);

char is_if(RSObject* expression);

RSObject* if_predicate(RSObject* exp);

RSObject* if_consequent(RSObject* exp);

RSObject* if_alternative(RSObject* exp);

RSObject* make_lambda(RSObject* parameters, RSObject* body);

char is_lambda(RSObject* exp);

RSObject* lambda_parameters(RSObject* exp);

RSObject* lambda_body(RSObject* exp);

RSObject* make_begin(RSObject* seq);

char is_begin(RSObject* exp);

RSObject* begin_actions(RSObject* exp);

char is_last_exp(RSObject* seq);

RSObject* first_exp(RSObject* seq);

RSObject* rest_exps(RSObject* seq);

char is_cond(RSObject* exp);

RSObject* cond_clauses(RSObject* exp);

RSObject* cond_predicate(RSObject* clause);

RSObject* cond_actions(RSObject* clause);

char is_cond_else_clause(RSObject* clause);

RSObject* sequence_to_exp(RSObject* seq);

RSObject* expand_clauses(RSObject* clauses);
RSObject* cond_to_if(RSObject* exp);

RSObject* make_application(RSObject* operator, RSObject* operands);

char is_application(RSObject* exp);

RSObject* operator(RSObject* exp);

RSObject* operands(RSObject* exp);

char is_no_operands(RSObject* ops);

RSObject* first_operand(RSObject* ops);

RSObject* rest_operands(RSObject* ops);

char is_let(RSObject* exp);

RSObject* let_bindings(RSObject* exp);

RSObject* let_body(RSObject* exp);

RSObject* binding_parameter(RSObject* binding);

RSObject* binding_argument(RSObject* binding);

RSObject* bindings_parameters(RSObject* bindings);

RSObject* bindings_arguments(RSObject* bindings);

RSObject* let_parameters(RSObject* exp);

RSObject* let_arguments(RSObject* exp);

RSObject* let_to_application(RSObject* exp);

char is_and(RSObject* exp);

RSObject* and_tests(RSObject* exp);

char is_or(RSObject* exp);

RSObject* or_tests(RSObject* exp);

RSObject* apply_operator(RSObject* arguments);

RSObject* prepare_apply_operands(RSObject* arguments);

RSObject* apply_operands(RSObject* arguments);

RSObject* eval_expression(RSObject* arguments);

RSObject* eval_environment(RSObject* arguments);

RSObject* list_of_values(RSObject* exps, RSObject* env);

RSObject* eval_assignment(RSObject* exp, RSObject* env);

RSObject* eval_definition(RSObject* exp, RSObject* env);

RSObject* eval(RSObject* exp, RSObject* env);

void write_pair(NSMutableString* out, RSObject* pair);

void _write(NSMutableString* out, RSObject* obj);
/***************************** REPL ******************************/
//
//int main(void) {
//    RSObject *exp;
//
//    printf("Welcome to Bootstrap Scheme. "
//           "Use ctrl-c to exit.\n");
//
//    init();
//
//    while (1) {
//        printf("> ");
//        exp = read(stdin);
//        if (exp == NULL) {
//            break;
//        }
//        write(stdout, eval(exp, the_global_environment));
//        printf("\n");
//    }
//
//    printf("Goodbye\n");
//
//    return 0;
//}
