RScheme 解释器
=============
### 背景

#### Scheme
Scheme 语言是一种交互式语言, 即: 用户输入一条指令, 解释器根据该 指令改变自身状态并返回一个结果, 输出该结果并等待用户输入下一条指令, 如此往复. 解释器对指令的操作称为 eval (即 evaluate, 求值). Eval 操作的行为主要有以下 4 种情 况: (a) 自求值表达式, 如数字, 字符串等, 对这一类表达式求值的结果仍是其自身 (例 如对1求值的结果还是1);(b) 符号 (即变量名), 在环境中查找, 如有对应, 则返回该对 应值, 否则报错; (c) 引用, 返回被引用的值; (d) 列表, 将列表中除第一项外的其余项应 用 (apply) 于第一项.Apply操作的行为有以下2种情况:(a) 语法 (syntax), 将参数直 接用于该语法; (b) 过程 (procedure), 将参数逐个求值 (eval), 将那些值用于该过程. (语法和过程均可能是解释器自身支持的或用户自己定义的.) 

#### Reactive Programming
维基百科对计算机程序的定义是：“A computer program, or just a program, is a sequence of instructions, written to perform a specified task with a computer”。计算机程序最早只是为了完成一行特定的任务，然而随着计算设备的普及，计算机程序的功能也由实现一个特定功能逐渐转向长时间提供服务的功能。为了解决这个问题，程序往往采用一个主循环来处理发生的事件，再根据事件，选择相应的处理方法。
```
function main
    initialize()
    while message != quit
        message := get_next_message()
        process_message(message)
    end while
end function
```
然而这个解决方案虽然解决了界面上提供服务时响应与资源协调的问题，但是其背后的数据流仍然有着此类的矛盾。尤其在Model View Controller的设计方案中，当View发生变化时，Controller函数能否用传统编程方法灵活地处理Model的变化，以及Model的变化如何及时而不影响性能地修改界面，仍然可能是一个问题。
Reactive Programming的出现寄予予了这类问题一个解决方案。Reactive Programming是基于消息的，是面向数据流变化的。也就是当Reactive Programming中的一个对象发生变化时，它会给相应的对象发送消息，对象会按照定义好的消息处理函数响应这项变化。这样，对外界变化的响应就简化成了根据界面改变改变对应的数据（或结构），预先定义好的模型会自行应用这个更改。
这种编程模式可以实现更加有效的响应以及更加高效的编程效率。

### 解释器概述

#### 实现目标
Objctve-C实现Scheme的Reactive拓展版本——RScheme的解释器

#### Scheme语言及我们的实现Rschme的简介


1. 我们实现的RScheme简介
除了Eval操作的基本流程之外，我们实现了Scheme的如下语法：lambda, define, if, set!, quote,

同时，我们添加了Reactive特性：
Reactive Programming（响应式编程）是一种面向数据流和变化传播的编程范式。这意味着可以在编程语言中很方便地表达静态或动态的数据流，而相关的计算模型会自动将变化的值通过数据流进行传播。
例如，在命令式编程环境中，a := b+c表示将表达式b+c的结果赋给a，而之后改变或的值不会影响。但在响应式编程中，a的值会随着b或c的更新而更新。
响应式编程最初是为了简化交互式用户界面的创建和实时系统动画的绘制而提出来的一种方法,例如，在MVC软件架构中，响应式编程允许将相关模型的变化自动反映到视图上，反之亦然。

针对Reactive特性，我们添加了如下的语法：
define signal：声明一个signal变量。signal变量与普通变量的区别是，signal变量是reactive的，signal变量的值的变化会随着signal变量之间的依赖关系进行传播，导致所有相关signal变量的值更新

以及一切对于普通变量适用的除了set的语法。

我们实现的RScheme解释器的特点
（1）原生支持整数，浮点数，及其互相运算
（2）垃圾回收
（3）尾递归优化
（4）具有reactive特性，可以定义signal变量以及signal变量之间的依赖关系
（5）针对Reactive Programming的演示图形界面
### 解释器设计
#### GUI
我们的RScheme解释器的图形界面部分是使用OS X平台上的Cocoa MVC框架实现的，主要图形界面如下图所示：

![GUI](/res/gui.png "GUI" )

1. 代码输入框
2. 结果输出框
3. 开始parse的确认按钮

![Alt text](/res/widget.png "Optional title")

4. 添加右图所示的signal显示视图（RShemeBox类），其中第一个textfield用于表示相关联的signal的变量名，第二个textfield显示其值，最下面的checkbox用于声明这个signal是否为数值型变量
5. signal演示view，所有4按钮创建的右图view都会在5中展示，并且位置可以在5中通过鼠标拖动
首先是parse过程相关的GUI具体实现：parse按钮被按下后，会触发其在相应的ViewController类中关联的IBAction（Cocoa中的事件动作），IBAction中将会读取目前代码输入框中的内容，然后进行词法语法分析，得到语法树后进行eval操作，然后讲结果写入结果输出框，并且将输入框的所有内容选中保证下次用户输入时会把之前的代码抹除（用户可以取消选中状态）。具体代码如下：
```
- (IBAction)parseButtonClicked:(NSButton*)sender
{
    NSString* parseString = self.inputTextField.string;
    [self.output setString:@""];
    [self.parser parse:parseString error:nil];
    NSMutableString* statements = [NSMutableString new];
    for (NSString* line in [parseString componentsSeparatedByString:@"\n"]) {
        [statements appendString:[NSString stringWithFormat:@">%@\n", line]];
    }
    [self appendOutput:self.output cause:statements];
    [self.inputTextField selectAll:self];
    [self updateUISignals];
}
```
其次便是signal相关的GUI演示部分的实现，同样，按钮4被按下后，会触发想关联的IBAction，通过代码新创建一个RSchemeBox类（具体的图形界面创建代码在RSchemeBox类声明中的initWithFrame方法中），然后添加为View5的子视图。

而对于RSchemeBox类的拖拽动作的实现则比较简单，RSchemeBox类在创建的过程中，添加了一个NSPanGestureRecognizer类的实例作为成员，该类实例可以监控鼠标对于视图的拖拽动作，并且可以关联IBAction在拖拽时进行触发；而在相应的IBAction中，只需要对于被拖拽的视图的边框位置进行相应更改即可。

#### 解释器
##### Regular Scheme
这方面我们实现了类似SICP上描述的Scheme实现的求值器，包含eval和apply两个核心函数，eval函数对过程进行求职求值，apply负责过程应用。
其中eval以一个表达式exp和环境env为参数根据exp分情况求值：
基本表达式（如各种自求值表达式、变量）：
	将本身或者环境中它所对应的值返回
特殊形式：
	引号表达式：返回被引用的表达式
	变量赋值或定义：修改环境，建立或修改相应约束
	if表达式：求值条件部分，分居情况求值相应子表达式
	lambda表达式：建立过程对象，包装过程的参数表体和环境
	begin表达式：按顺序求值其中各个表达式
	cond表达式：将其变换为一系列if表达式求值
组合过程：
	递归地求职各个子表达式，将得到的过程和参数进行apply。
而apply以一个过程和参数表作为参数有两种情况：
基本过程：
	用直接分情况调用Objective-C函数
复合过程：
	建立新环境，在新环境中顺序求值表达式
##### Reactive Scheme
Reactive Scheme 是我们实现的Scheme语言的一个扩展，我们修改了词法语法解释，使得以’$’开头的symbol被解释为一个signal，当一个signal在语法书中自成一个元组时，则视为取signal在执行时的值，除此之外，则视为取signal本身进行求职，这样求值出来的结果仍然为一个signal，当一个statement在全局环境下仍然为signal时，它则会在其敏感的signal发生变化时重新进行求值。
我们采用了类似队列式的传播过程，当一个signal发生变化时，会添加到changedSignal，当本语句执行完之后，Parser会检查changedSignal，如果有，将会顺序执行所有关于changedSignal敏感的语句（这个过程也可能产生新的变化），最终当changedSignal为空时，停止传播。
具体函数的实现方法见框图：

![Alt text](/res/parser.png "Optional title")

![Alt text](/res/propagate.tif "Optional title")

### 总结
通过本次实习，除了进一步巩固了上学期编译原理课程的讲授知识外，更是亲身体验了设计和编写相对较大的完整实用工程的过程，从中收获了许多的经验和教训。首先便是设计上的障碍。因为我们是在一门成熟语言上面添加新的语法，因而我们上来先选择了直接实现普通Scheme的解释器，并没有太多的考虑我们需要添加的新的语法特性，因而在后来给我们添加reactive特性添加了些许困难；如果我们一开始就设计好，而不是做完了一般之后再在设计方案上面添加新的设计，也许我们在后来遇到的障碍就会少一些；另一方面，因为我们主要目的在于reacitive特性的实现，而并不希望耗费太多精力在普通scheme解释器的实现上面，因而我们上来在实现普通scheme解释器的时候，主要参考了bootstrap scheme的实现，使用了直接强行枚举的词法语法分析实现，并没有使用flex和bison这类封装好的词法语法分析库，因而这一部分的代码的模块性并不好，给后来添加reactive特性相关的语法带来了很大的不便，最终导致了我们重构了我们的词法语法分析部分，这也充分让我们体会到了事前细致周到的设计与规划对于这样完整工程的实现的重要意义。
我们两位组员也在这次合作实习课程中体会到了这种合作项目中，组员之间的沟通与讨论的重要性。例如在解决bison中union结构与Objective-C的ARC（自动引用计数）机制的冲突问题时，我们曾经起过很大的争执；不过我们后来通过相互的讨论说服，最终才确定下了一种相对比较合适的解决方案。
现在回想起这次的实习过程，无论是我们的选题过程，还是设计过程，还是实现过程，以及组内的相互合作沟通过程，我们都深感获益良多。
