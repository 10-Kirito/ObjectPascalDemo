// 单元名称的声明，这里和.pas文件的名称是一样的!
unit Chapter1;
// 接口的声明，这里可以只写声明，在implementation处书写定义!
// 注意!!!如果想要被其它的文件访问，只能在该部分书写!
interface

// 这里可以书写上述声明的定义，该处可以省略参数（若未省略必须与声明一致）;
// 此部分可以定义常量、变量、例程等，但是只能在本单元内使用!
implementation

// (Optional)
// 在程序启动的时候运行，若多个单元均含有该部分代码，则按照uses从句当中引用的顺序执行！ (相当于单元的构造函数 )
initialization

// (Optional)
// 程序结束的时候运行，仅当initialization部分存在时才可以使用该部分。
// 当多个单元均存在该部分的时候，执行顺序与initialization顺序相反（相当于单元的析构函数）
finalization


// 必须要书写的结束符号
end.
