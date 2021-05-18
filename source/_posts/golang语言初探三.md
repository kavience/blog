---
title: golang语言初探三
catalog: true
hidden: false
tags:
  - golang
categories:
  - backend
translate_title: a-preliminary-study-of-golang-language3
date: 2021-05-18 09:55:55
subtitle: 研究了一下 golang 相关的文档，写下这篇 golang 入门日记，包含 golang 基础教程，这是 golang 语言初探第三篇
keywords: golang,golang入门,golang教程,golang入门文档
header_img:
---

## what
研究了一下 golang 相关的文档，写下这篇 golang 入门日记，包含 golang 基础教程，这是 golang 语言初探第三篇。

- [golang语言初探一](/backend/a-preliminary-study-of-golang-language1.html)
- [golang语言初探二](/backend/a-preliminary-study-of-golang-language2.html)
- golang语言初探三

## why
周末的时候研究了一下 golang 相关的文档，根据自己的工作经验，我觉得这门语言在未来一定会大放异彩，其实现在也比较热门了。主要有以下几个特点：

- 语法简单，golang 的关键字才 25 个，入门也非常简单
- 天然支持高并发，适用于大型微服务应用
- 跨平台，可编译出支持各大主流平台的应用，且毫无依赖

经过对 golang 的这些了解，顿时感觉有点兴趣了，在这里记录一些入门的资料。

## how

### 基本流程控制
#### if 语句
if 语句一般会由关键字 if 、条件表达式和由花括号包裹的代码块组成。所谓代码块，即是包含了若干表达式和语句的序列。在 Go 语言中，代码块必须由花括号包裹。另外，这里的条件表达式是指其结果类型是 bool 的表达式。一条最简单的 if 语句可以是：
```go
if 100 > number { 
    number += 3
}
```
这里的标识符 number 可以代表一个 int 类型的值。这条 if 语句的意思是：如果 number 的值小于 100 ，那么就把其值增加 3 。我还可以在此之上添加 else 分支，就像这样：
```go
if 100 > number {
    number += 3
} else {
    number -= 2
}
```
else 分支的含义是，提供在条件不成立（具体到这里是 number 的值不小于 100 ）的情况下需要执行的操作。除此之外， if 语句还支持串联。请看下面的例子：  
```go
if 100 > number {
    number += 3
} else if 100 < number {
    number -= 2
} else {
    fmt.Println("OK!")
}   
```
可以看到，上述代码很像是把多条 if 语句串接在一起了一样。这样的 if 语句用于对多个条件的综合判断。上述语句的意思是，若 number 的值小于 100 则将其加 3 ，若 number 的值大于 100 则将其减 2 ，若 number 的值等于 100 则打印 OK! 。
  
> 注意，我们至此还未对 number 变量进行声明。上面的示例也因此不能通过编译。

我们可以用单独的语句来声明该变量并为它赋值。但是我们也可以把这样的变量赋值直接加入到 if 子句中。示例如下：
```go
if number := 4; 100 > number {
    number += 3
} else if 100 < number {
    number -= 2
} else {
    fmt.Println("OK!")
}   
```
这里的 `number := 4` 被叫做 if 语句的初始化子句。它应被放置在 if 关键字和条件表达式之间，并与前者由空格分隔、与后者由英文分号;分隔。注意，我们在这里使用了短变量声明语句，即：在声明变量 number 的同时为它赋值。这意味着这里的 number 被视为一个新的变量。它的作用域仅在这条 i 语句所代表的代码块中。也可以说，变量 number 对于该 if 语句之外的代码来说是不可见的。我们若要在该 if 语句以外使用 number 变量就会造成编译错误。

另外还要注意，即使我们已经在这条if语句所代表的代码块之外声明了 number 变量，这里的语句 number := 4 也是合法的。请看这个例子：
```go
var number int
if number := 4; 100 > number {
    number += 3
} else if 100 < number {
    number -= 2
} else {
    fmt.Println("OK!")
}
```
这种写法有一个专有名词，叫做：标识符的重声明。实际上，只要对同一个标识符的两次声明各自所在的代码块之间存在包含的关系，就会形成对该标识符的重声明。具体到这里，第一次声明的 number 变量所在的是该 if 语句的外层代码块，而 number := 4 所声明的 number 变量所在的是该if语句的代表代码块。它们之间存在包含关系。因此对 number 的重声明就形成了。
  
这种情况造成的结果就是， if 语句内部对 number 的访问和赋值都只会涉及到第二次声明的那个 number 变量。这种现象也被叫做标识符的遮蔽。上述代码被执行完毕之后，第二次声明的 number 变量的值会是7，而第一次声明的 number 变量的值仍会是 0 。

#### switch 语句
与串联的 if 语句类似， switch 语句提供了一个多分支条件执行的方法。不过在这里用一个专有名词来代表分支——`case`。每一个 case 可以携带一个表达式或一个类型说明符。前者又可被简称为 case 表达式。因此， **Go 语言的 switch 语句又分为表达式 switch 语句和类型 switch 语句**。
  
先说表达式 switch 语句。在此类 switch 语句中，每个 case 会携带一个表达式。与 if 语句中的条件表达式不同，这里的 case 表达式的结果类型并不一定是 bool 。不过，它们的结果类型需要与 switch 表达式的结果类型一致。所谓 switch 表达式是指 switch 语句中要被判定的那个表达式。 switch 语句会依据该表达式的结果与各个 case 表达式的结果是否相同来决定执行哪个分支。请看下面的示例：
```go
var name string
// 省略若干条语句
switch name {
case "Golang":
    fmt.Println("A programming language from Google.")
case "Rust":
    fmt.Println("A programming language from Mozilla.")
default:
    fmt.Println("Unknown!")
}  
```
可以看到，在上述 switch 语句中， name 充当了 switch 表达式，而" Go "和" Rust "充当了 case 表达式。它们的结果类型是一致的，都是 string 。顺便说一句，可以有只包含一个字面量或标识符的表达式。它们是最简单的表达式，属于基本表达式的一种。

请大家注意 switch 语句的写法。 switch 表达式必须紧随 switch 关键字出现。在后面的花括号中，一个关键字 case、case 表达式、冒号以及后跟的若干条语句组成为一条 case 语句。在 switch 语句中可以有若干条 case 语句。 Go 语言会依照从上至下的顺序对每一条 case 语句中 case 表达式进行求值。只要被发现其表达式与 switch 表达式的结果相同，该 case 语句就会被选中。它包含的那些语句就会被执行。而其余的 case 语句则会被忽略。

switch 语句中还可以存在一个特殊的 **case——default case** 。顾名思义，当没有一个常规的 case 被选中的时候，default case 就会被选中。上面示例中就存在一个default case 。它由关键字 default 、冒号和后跟的一条语句组成。实际上， default case 不一定被追加在最后。它可以是第一个 case ，或者出现在任意顺位上。

另外，与 if 语句一样， switch 语句还可以包含初始化子句，且其出现位置和写法也如出一辙。如：
```go
names := []string{"Golang", "Java", "Rust", "C"}
switch name := names[0]; name {
case "Golang":
    fmt.Println("A programming language from Google.")
case "Rust":
    fmt.Println("A programming language from Mozilla.")
default:
    fmt.Println("Unknown!")
}
```

另一个类型 switch 语句。它与一般形式有两点差别。第一点，紧随 case 关键字的不是表达式，而是类型说明符。类型说明符由若干个类型字面量组成，且多个类型字面量之间由英文逗号分隔。第二点，它的 switch 表达式是非常特殊的。这种特殊的表达式也起到了类型断言的作用，但其表现形式很特殊，如：v.(type)，其中 v 必须代表一个接口类型的值。注意，该类表达式只能出现在类型 switch 语句中，且只能充当 switch 表达式。一个类型 switch 语句的示例如下：
```go
v := 11
switch i := interface{}(v).(type) {
case int, int8, int16, int32, int64:
    fmt.Printf("A signed integer: %d. The type is %T. \n", i, i)
case uint, uint8, uint16, uint32, uint64:
    fmt.Printf("A unsigned integer: %d. The type is %T. \n", i, i)
default:
    fmt.Println("Unknown!")
}
```
请注意，我们在这里把 switch 表达式的结果赋给了一个变量。如此一来，我们就可以在该 switch 语句中使用这个结果了。这段代码被执行后，标准输出上会打印出 `A signed integer: 11. The type is int.`。

最后，我们来说一下 fallthrough 。它既是一个关键字，又可以代表一条语句。 fallthrough 语句可被包含在表达式 switch 语句中的 case 语句中。它的作用是使控制权流转到下一个 case 。不过要注意， fallthrough 语句仅能作为 case 语句中的最后一条语句出现。并且，包含它的 case 语句不能是其所属 switch 语句的最后一条 case 语句。
#### for 语句
for 语句代表着循环。一条语句通常由关键字 for 、初始化子句、条件表达式、后置子句和以花括号包裹的代码块组成。其中，初始化子句、条件表达式和后置子句之间需用分号分隔。示例如下：
```go
for i := 0; i < 10; i++ {
    fmt.Print(i, " ")
}  
```
我们可以省略掉初始化子句、条件表达式、后置子句中的任何一个或多个，不过起到分隔作用的分号一般需要被保留下来，除非在仅有条件表达式或三者全被省略时分号才可以被一同省略。

我们可以把上述的初始化子句、条件表达式、后置子句合称为for子句。实际上，for语句还有另外一种编写方式，那就是用 range 子句替换掉 for 子句。 range 子句包含一个或两个迭代变量（用于与迭代出的值绑定）、特殊标记 := 或 = 、关键字 range 以及 range 表达式。其中， range 表达式的结果值的类型应该是能够被迭代的，包括：字符串类型、数组类型、数组的指针类型、切片类型、字典类型和通道类型。例如：
```go
for i, v := range "Go语言" {
    fmt.Printf("%d: %c\n", i, v)
} 
```
对于字符串类型的被迭代值来说，for语句每次会迭代出两个值。第一个值代表第二个值在字符串中的索引，而第二个值则代表该字符串中的某一个字符。迭代是以索引递增的顺序进行的。例如，上面的 for 语句被执行后会在标准输出上打印出：

```
0: G
1: o
2: 语
5: 言 
```

可以看到，这里迭代出的索引值并不是连续的。下面我们简单剖析一下此表象的本质。我们知道，字符串的底层是以字节数组的形式存储的。而在 Go 语言中，字符串到字节数组的转换是通过对其中的每个字符进行 UTF-8 编码来完成的。字符串"Go语言"中的每一个字符与相应的字节数组之间的对应关系如下：

![for](/img/blog_img/golang-for.jpeg)

> 注意，一个中文字符在经过 UTF-8 编码之后会表现为三个字节。所以，我们用 `语[0]、语[1]和、语[2]` 分别表示字符'语'经编码后的第一、二、三个字节。对于字符'言'，我们如法炮制。

对照这张表格，我们就能够解释上面那条 for 语句打印出的内容了，即：**每次迭代出的第一个值所代表的是第二个字符值经编码后的第一个字节在该字符串经编码后的字节数组中的索引值**。

对于数组值、数组的指针值和切片之来说，range 子句每次也会迭代出两个值。其中，第一个值会是第二个值在被迭代值中的索引，而第二个值则是被迭代值中的某一个元素。同样的，迭代是以**索引递增**的顺序进行的。

对于字典值来说，range 子句每次仍然会迭代出两个值。显然，第一个值是字典中的某一个键，而第二个值则是该键对应的那个值。
> 注意，对字典值上的迭代， Go 语言是不保证其顺序的。

携带 range 子句的 for 语句还可以应用于一个通道值之上。其作用是不断地从该通道值中接收数据，不过每次只会接收一个值。注意，如果通道值中没有数据，那么 for 语句的执行会处于阻塞状态。无论怎样，这样的循环会一直进行下去。直至该通道值被关闭，for 语句的执行才会结束。

最后，我们来说一下 break 语句和 continue 语句。它们都可以被放置在 for 语句的代码块中。前者被执行时会使其所属的 for 语句的执行立即结束，而后者被执行时会使当次迭代被中止（当次迭代的后续语句会被忽略）而直接进入到下一次迭代。
#### select 语句
select 语句属于条件分支流程控制方法，**不过它只能用于通道**。它可以包含若干条 case 语句，并根据条件选择其中的一个执行。进一步说， select 语句中的 case 关键字只能后跟**用于通道的发送操作的表达式以及接收操作的表达式或语句**。示例如下：
```go
ch1 := make(chan int, 1)
ch2 := make(chan int, 1)
// 省略若干条语句
select {
case e1 := <-ch1:
    fmt.Printf("1th case is selected. e1=%v.\n", e1)
case e2 := <-ch2:
    fmt.Printf("2th case is selected. e2=%v.\n", e2)
default:
    fmt.Println("No data!")
} 
```
如果该 select 语句被执行时通道 ch1 和 ch2 中都没有任何数据，那么肯定只有 default case 会被执行。但是，只要有一个通道在当时有数据就不会轮到 default case 执行了。显然，对于包含通道接收操作的 case 来讲，其执行条件就是通道中存在数据（或者说通道未空）。如果在当时有数据的通道多于一个，那么 Go 语言会通过一种伪随机的算法来决定哪一个 case 将被执行。

另一方面，对于包含通道发送操作的 case 来讲，其执行条件就是通道中至少还能缓冲一个数据（或者说通道未满）。类似的，当有多个 case 中的通道未满时，它们会被随机选择。请看下面的示例：
```go
ch3 := make(chan int, 100)
// 省略若干条语句
select {
case ch3 <- 1:
    fmt.Printf("Sent %d\n", 1)
case ch3 <- 2:
    fmt.Printf("Sent %d\n", 2)
default:
    fmt.Println("Full channel!")
}
```
该条 select 语句的两个 case 中包含的都是针对通道 ch3 的发送操作。如果我们把这条语句置于一个循环中，那么就相当于用有限范围的随机整数集合去填满一个通道。

> 请注意，如果一条 select 语句中不存在 default case ， 并且在被执行时其中的所有 case 都不满足执行条件，那么它的执行将会被阻塞！当前流程的进行也会因此而停滞。直到其中一个 case 满足了执行条件，执行才会继续。我们一直在说 case 执行条件的满足与否取决于其操作的通道在当时的状态。这里特别强调一点，即：未被初始化的通道会使操作它的 case 永远满足不了执行条件。对于针对它的发送操作和接收操作来说都是如此。

最后提一句， break 语句也可以被包含在 select 语句中的 case 语句中。它的作用是立即结束当前的 select 语句的执行，不论其所属的 case 语句中是否还有未被执行的语句。

### 更多流程控制
#### defer 语句
与 select 语句一样， Go 语言中的 defer 语句也非常独特，而且比前者有过之而无不及。 defer 语句仅能被放置在函数或方法中。它由关键字 defer 和一个调用表达式组成。注意，这里的调用表达式所表示的既不能是对 Go 语言内建函数的调用也不能是对 Go 语言标准库代码包 unsafe 中的那些函数的调用。实际上，满足上述条件的调用表达式被称为表达式语句。请看下面的示例：
```go
func readFile(path string) ([]byte, error) {
    file, err := os.Open(path)
    if err != nil {
        return nil, err
    }
    defer file.Close()
    return ioutil.ReadAll(file)
}
```
函数 readFile 的功能是读出指定文件或目录（以下统称为文件）本身的内容并将其返回，同时当有错误发生时立即向调用方报告。其中， os 和 ioutil （导入路径是 io/ioutil ）代表的都是 Go 语言标准库中的代码包。请注意这个函数中的倒数第二条语句。我们在打开指定文件且未发现有错误发生之后，紧跟了一条 defer 语句。其中携带的表达式语句表示的是对被打开文件的关闭操作。注意，当这条 defer 语句被执行的时候，其中的这条表达式语句并不会被立即执行。它的确切的执行时机是在其所属的函数（这里是 readFile ）的执行即将结束的那个时刻。也就是说，在 readFile 函数真正结束执行的前一刻， file.Close() 才会被执行。这也是 defer 语句被如此命名的原因。我们在结合上下文之后就可以看出，语句 defer file.Close() 的含义是在打开文件并读取其内容后及时地关闭它。该语句可以保证在 readFile 函数将结果返回给调用方之前，那个文件或目录一定会被关闭。这实际上是一种非常便捷和有效的保险措施。
   
更为关键的是，无论 readFile 函数正常地返回了结果还是由于在其执行期间有运行时恐慌发生而被剥夺了流程控制权，其中的 file.Close() 都会在该函数即将退出那一刻被执行。这就更进一步地保证了资源的及时释放。
   
注意，当一个函数中存在多个 defer 语句时，它们携带的表达式语句的执行顺序一定是它们的出现顺序的倒序。下面的示例可以很好的证明这一点：
```go
func deferIt() {
    defer func() {
        fmt.Print(1)
    }()
    defer func() {
        fmt.Print(2)
    }()
    defer func() {
        fmt.Print(3)
    }()
    fmt.Print(4)
}
```
deferIt 函数的执行会使标准输出上打印出 4321 。请大家猜测下面这个函数被执行时向标准输出打印的内容，并真正执行它以验证自己的猜测。最后论证一下自己的猜测为什么是对或者错的。
```go
func deferIt2() {
    for i := 1; i < 5; i++ {
        defer fmt.Print(i)
    }
}
```
最后，对于 defer 语句，我还有两个特别提示：
   
1. defer 携带的表达式语句代表的是对某个函数或方法的调用。这个调用可能会有参数传入，比如：fmt.Print(i + 1) 。如果代表传入参数的是一个表达式，那么在 defer 语句被执行的时候该表达式就会被求值了。注意，这与被携带的表达式语句的执行时机是不同的。请揣测下面这段代码的执行：
```go
func deferIt3() {
    f := func(i int) int {
        fmt.Printf("%d ",i)
        return i * 10
    }
    for i := 1; i < 5; i++ {
        defer fmt.Printf("%d ", f(i))
    }
}
```
它在被执行之后，标准输出上打印出1 2 3 4 40 30 20 10 。
   
2. 如果 defer 携带的表达式语句代表的是对匿名函数的调用，那么我们就一定要非常警惕。请看下面的示例：
```go
func deferIt4() {
    for i := 1; i < 5; i++ {
        defer func() {
            fmt.Print(i)
        }()
    }
}     
```
deferIt4 函数在被执行之后标出输出上会出现 5555 ，而不是 4321 。原因是 defer 语句携带的表达式语句中的那个匿名函数包含了对外部（确切地说，是该 defer 语句之外）的变量的使用。注意，等到这个匿名函数要被执行（且会被执行 4 次）的时候，包含该 defer 语句的那条 for 语句已经执行完毕了。此时的变量 i 的值已经变为了 5 。因此该匿名函数中的打印函数只会打印出 5 。正确的用法是：把要使用的外部变量作为参数传入到匿名函数中。修正后的 deferIt4 函数如下：
```go
func deferIt4() {
    for i := 1; i < 5; i++ {
        defer func(n int) {
            fmt.Print(n)
        }(i)
    }
}
```
#### 异常处理 error
Go 语言的函数可以一次返回多个结果。这就为我们温和地报告错误提供了语言级别的支持。实际上，这也是 Go 语言中处理错误的惯用法之一。
```go
func readFile(path string) ([]byte, error) {
    file, err := os.Open(path)
    if err != nil {
        return nil, err
    }
    defer file.Close()
    return ioutil.ReadAll(file)
}
```
函数 readFile 有两个结果声明。第二个结果声明的类型是 error 。 error 是 Go 语言内置的一个接口类型。它的声明是这样的：
```go
type error interface { 
    Error() string
}
```
显然，只要一个类型的方法集合包含了名为 Error 、无参数声明且仅声明了一个 string 类型的结果的方法，就相当于实现了 error 接口。 os.Open 函数的第二个结果值就的类型就是这样的。我们把它赋给了变量 err 。也许你已经意识到，在 Go 语言中，函数与其调用方之间温和地传递错误的方法即是如此。

在调用了 os.Open 函数并取得其结果之后，我们判断 err 是否为 nil 。如果答案是肯定的，那么就直接把该错误（这里由 err 代表）返回给调用方。这条 if 语句实际上是一条卫述语句。这样的语句会检查流程中的某个步骤是否存在异常，并在必要时中止流程并报告给上层的程序（这里是调用方）。在 Go 语言的标准库以及很多第三方库中，我们经常可以看到这样的代码。我们也建议大家在自己的程序中善用这样的卫述语句。

现在我们把目光聚焦到 readFile 函数中的最后一条语句上。这是一条 return 语句。它把对 ioutil.ReadAll 函数的调用的结果直接作为 readFile 函数的结果返回了。实际上， ioutil.ReadAll 函数的结果声明列表与 readFile 的结果声明列表是一致的。也就是说，它们声明的结果的数量、类型和顺序都是相同的。因此，我们才能够做这种返回结果上的“嫁接”。这又是一个 Go 语言编码中的惯用法。

好了，在知晓怎样在传递错误之后，让我们来看看怎样创造错误。没错，在很多时候，我们需要创造出错误（即 error 类型的值）并把它传递给上层程序。这很简单。只需调用标准库代码包 errors 的 New 函数即可。例如，我们只要在 readFile 函数的开始处加入下面这段代码就可以更快的在参数值无效时告知调用方：
```go
if path == "" {
    return nil, errors.New("The parameter is invalid!")
}   
```
errors.New 是一个很常用的函数。在 Go 语言标准库的代码包中有很多由此函数创建出来的错误值，比如 os.ErrPermission 、 io.EOF 等变量的值。我们可以很方便地用操作符 == 来判断一个 error 类型的值与这些变量的值是否相等，从而来确定错误的具体类别。就拿 io.EOF 来说，它代表了一个信号。该信号用于通知数据读取方已无更多数据可读。我们在得到这样一个错误的时候不应该把它看成一个真正的错误，而应该只去结束相应的读取操作。请看下面的示例：
```go
br := bufio.NewReader(file)
var buf bytes.Buffer
for {
    ba, isPrefix, err := br.ReadLine()
    if err != nil {
        if err == io.EOF {
            break
        }
        fmt.Printf("Error: %s\n", err)
        break
    }
    buf.Write(ba)
    if !isPrefix {
        buf.WriteByte('\n')
    }
}
```
可以看到，这段代码使用到了前面示例中的变量 file 。它的功能是把 file 代表的文件中的所有内容都读取到一个缓冲器（由变量 buf 代表）中。请注意，该示例中的第 6 ~ 8 行代码。如果判定 err 代表的错误值等于 io.EOF 的值（即它们是同一个值），那么我们只需退出当前的循环以使读取操作结束即可。

总之，只要能够善用 error 接口、 errors.New 函数和比较操作符==，我们就可以玩儿转 Go 语言中的一般错误处理。
#### 异常处理 panic
panic 可被意译为运行时恐慌。因为它只有在程序运行的时候才会被“抛出来”。并且，恐慌是会被扩散的。当有运行时恐慌发生时，它会被迅速地向调用栈的上层传递。如果我们不显式地处理它的话，程序的运行瞬间就会被终止。这里有一个专有名词——程序崩溃。内建函数 panic 可以让我们人为地产生一个运行时恐慌。不过，这种致命错误是可以被恢复的。在 Go 语言中，内建函数 recover 就可以做到这一点。
  
实际上，内建函数 panic 和 recover 是天生的一对。前者用于产生运行时恐慌，而后者用于“恢复”它。不过要注意， recover 函数必须要在 defer 语句中调用才有效。因为一旦有运行时恐慌发生，当前函数以及在调用栈上的所有代码都是失去对流程的控制权。只有 defer 语句携带的函数中的代码才可能在运行时恐慌迅速向调用栈上层蔓延时“拦截到”它。这里有一个可以起到此作用的 defer 语句的示例：
```go
defer func() {
    if p := recover(); p != nil {
        fmt.Printf("Fatal error: %s\n", p)
    }
}()
```
在这条 defer 语句中，我们调用了 recover 函数。该函数会返回一个 interface{} 类型的值。还记得吗？ interface{} 代表空接口。 Go 语言中的任何类型都是它的实现类型。我们把这个值赋给了变量 p 。如果 p 不为 nil ，那么就说明当前确有运行时恐慌发生。这时我们需根据情况做相应处理。注意，一旦 defer 语句中的 recover 函数调用被执行了，运行时恐慌就会被恢复，不论我们是否进行了后续处理。所以，我们一定不要只“拦截”不处理。
  
我们下面来反观 panic 函数。该函数可接受一个 interface{} 类型的值作为其参数。也就是说，我们可以在调用 panic 函数的时候可以传入任何类型的值。不过，我建议大家在这里只传入 error 类型的值。这样它表达的语义才是精确的。更重要的是，当我们调用 recover 函数来“恢复”由于调用 panic 函数而引发的运行时恐慌的时候，得到的值正是调用后者时传给它的那个参数。因此，有这样一个约定是很有必要的。

总之，运行时恐慌代表程序运行过程中的致命错误。我们只应该在必要的时候引发它。人为引发运行时恐慌的方式是调用 panic 函数。 recover 函数是我们常会用到的。因为在通常情况下，我们肯定不想因为运行时恐慌的意外发生而使程序崩溃。最后，在“恢复”运行时恐慌的时候，大家一定要注意处理措施的得当。
#### go 语句
go 语句和通道类型是 Go 语言的并发编程理念的最终体现。相比之下， go 语句在用法上要比通道简单很多。与 defer 语句相同， go 语句也可以携带一条表达式语句。
> 注意，go 语句的执行会很快结束，并不会对当前流程的进行造成阻塞或明显的延迟。一个简单的示例如下：
```go
go fmt.Println("Go!")
```
可以看到， go 语句仅由一个关键字 go 和一条表达式语句构成。同样的， go 语句的执行与其携带的表达式语句的执行在时间上没有必然联系。这里能够确定的仅仅是后者会在前者完成之后发生。在 go 语句被执行时，其携带的函数（也被称为 go 函数）以及要传给它的若干参数（如果有的话）会被封装成一个实体（即 Goroutine ），并被放入到相应的待运行队列中。 Go 语言的运行时系统会适时的从队列中取出待运行的 Goroutine 并执行相应的函数调用操作。注意，对传递给这里的函数的那些参数的求值会在 go 语句被执行时进行。这一点也是与 defer 语句类似的。
  
正是由于 go 函数的执行时间的不确定性，所以 Go 语言提供了很多方法来帮助我们协调它们的执行。其中最简单粗暴的方法就是调用 time.Sleep 函数。请看下面的示例：
```go
package main

import (
    "fmt"
)

func main() {
    go fmt.Println("Go!")
}  
```
这样一个命令源码文件被运行时，标准输出上不会有任何内容出现。因为还没等 Go 语言运行时系统调度那个 go 函数执行，主函数 main 就已经执行完毕了。函数 main 的执行完毕意味着整个程序的执行的结束。因此，这个 go 函数根本就没有执行的机会。
  
但是，当我们在上述 go 语句的后面添加一条对 time.Sleep 函数的调用语句之后情况就会不同了：
```go
package main

import (
    "fmt"
    "time"
)

func main() {
    go fmt.Println("Go!")
    time.Sleep(100 * time.Millisecond)
}
```
语句 time.Sleep(100 * time.Millisecond) 会把 main 函数的执行结束时间向后延迟 100 毫秒。 100 毫秒虽短暂，但足够 go 函数被调度执行的了。上述命令源码文件在被运行时会如我们所愿地在标准输出上打印出 Go! 。 

另一个比较绅士的做法是在 main 函数的最后调用 `runtime.Gosched` 函数。相应的程序版本如下：
```go
package main

import (
    "fmt"
    "runtime"
)

func main() {
    go fmt.Println("Go!")
    runtime.Gosched()
}
```
runtime.Gosched 函数的作用是让当前正在运行的 Goroutine （这里是运行 main 函数的那个 Goroutine ）暂时“休息”一下，而让 Go 运行时系统转去运行其它的 Goroutine （这里是与 `go fmt.Println("Go!")` 对应并会封装 `fmt.Println("Go!")` 的那个 Goroutine ）。如此一来，我们就更加精细地控制了对几个 Goroutine 的运行的调度。

当然，我们还有其它方法可以满足上述需求。并且，如果我们需要去左右更多的 Goroutine 的运行时机的话，下面这种方法也许更合适一些。请看代码：
```go
package main

import (
    "fmt"
    "sync"
)

func main() {
    var wg sync.WaitGroup
    wg.Add(3)
    go func() {
        fmt.Println("Go!")
        wg.Done()
    }()
    go func() {
        fmt.Println("Go!")
        wg.Done()
    }()
    go func() {
        fmt.Println("Go!")
        wg.Done()
    }()
    wg.Wait()
}
```
sync.WaitGroup 类型有三个方法可用—— Add、 Done 和 Wait 。 Add 会使其所属值的一个内置整数得到相应增加， Done 会使那个整数减 1 ，而 Wait 方法会使当前 Goroutine（这里是运行 main 函数的那个 Goroutine ）阻塞直到那个整数为 0 。这下你应该明白上面这个示例所采用的方法了。我们在 main 函数中启用了三个 Goroutine 来封装三个 go 函数。每个匿名函数的最后都调用了 wg.Done 方法，并以此表达当前的 go 函数会立即执行结束的情况。当这三个 go 函数都调用过 wg.Done 函数之后，处于 main 函数最后的那条 wg.Wait() 语句的阻塞作用将会消失， main 函数的执行将立即结束。
  
## 总结

本系列只是 golang 入门语法，是根据[慕课网-Go语言第一课](https://www.imooc.com/learn/345)学习，并记录下来，方便日后查阅，加深印象。感谢慕课网。

（完）