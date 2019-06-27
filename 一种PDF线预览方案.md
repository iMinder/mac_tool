## PDF线预览方案研究

腾讯文档要实现PDF的导入以及预览能力，后期还要实现导出到其他文档格式的能力。前端要实现PDF的在线预览能力，先对几种方案进行介绍。

### PDF介绍

PDF是一种用独立于[应用程序](https://zh.wikipedia.org/wiki/%E6%87%89%E7%94%A8%E7%A8%8B%E5%BC%8F)、[硬件](https://zh.wikipedia.org/wiki/%E7%A1%AC%E9%AB%94)、[操作系统](https://zh.wikipedia.org/wiki/%E4%BD%9C%E6%A5%AD%E7%B3%BB%E7%B5%B1)的方式呈现[文档](https://zh.wikipedia.org/wiki/%E6%96%87%E6%A1%A3)的[文件格式](https://zh.wikipedia.org/wiki/%E6%AA%94%E6%A1%88%E6%A0%BC%E5%BC%8F)。每个PDF文件包含固定布局的平面文档的完整描述，包括文本、字形、图形及其他需要显示的信息。其强大的功能(支持文字\图片\表单\链接\音乐\视频等)以及平台无关性，使其成为了最受欢迎文档传播方式之一。当前最新的PDF标准是[PDF 1.7](<http://wwwimages.adobe.com/www.adobe.com/content/dam/acom/en/devnet/pdf/pdfs/pdf_reference_1-7.pdf>)。

和我们熟悉的HTML、XML等结构化文件格式类似，PDF格式包含关键字，分隔符、数据等。不同的是PDF是按照二进制流的方式保存的。下面是一个简单格式的PDF内容，保存成PDF即可打开。

```PDF
%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 3 0 R
/Outlines 2 0 R
>>
endobj

2 0 obj
<<
/Type /Outlines
/Count 0
>>
endobj

3 0 obj
<<
/Type /Pages
/Count 1
/Kids [4 0 R]
>>
endobj

4 0 obj
<<
/Type /Page
/Parent 3 0 R
/Resources << /Font << /F1 7 0 R >> /ProcSet 6 0 R >>
/MediaBox [0 0 500 500]
/Contents 5 0 R
>>
endobj

5 0 obj
<< /Length 40 >>
stream
BT
/F1 60 Tf
100 100 Td (Hello World) Tj
ET
endstream
endobj

6 0 obj
[/PDF /Text]
endobj

7 0 obj
<<
/Type /Font
/Subtype /Type1
/Name /F1
/BaseFont /Helvetica
>>
endobj

xref
0  0

trailer
<<
/Size 7
/Root 1 0 R
>>

startxref
553
%%EOF

```

PDF的基本组成：

- 文件头： 指明了该文件所遵从的PDF规范的版本号，它出现在PDF文件的第一行。
- 文件体： PDF文件的主要部分，由一系列对象组成。
- 交叉引用表： 为了能对间接对象进行随机存取而设立的一个间接对象的地址索引表。
- 文件尾： 声明了交叉引用表的地址，即指明了文件体的根对象（Catalog），从而能够找到PDF文件中各个对象体的位置，达到随机访问。另外还保存了PDF文件的加密等安全信息。

![PDF结构图](/Users/iminder/Downloads/PDF结构图.png)

作为一种结构化的文件格式，一个PDF文档是由一些称为“对象”的模块组成的。并且每个对象都有数字标号，这样的话可以这些对象就可以被其他的对象所引用。这些对象不需要按照顺序出现在PDF文档里面，出现的顺序可以是任意的，因此顺序读取是不可能的。

![PDF格式解析示意图](/Users/iminder/Downloads/PDF格式解析示意图.png)这里是要说明，由于PDF这种格式，对PDF的流式解析是不行的。需要对整个PDF文件进行解析。

### 几种常见Web预览方案

针对PDF这种格式的Web预览，目前主流的方式有如下几种。

#### 转成HTML

服务器将PDF转成HTML，然后给前端吐HTML加载即可。开源的工具有很多，开源的pdf2htmlEX(不再维护)，pdftohtml(command line)等很多均支持。我们后台使用的ASPose.PDF也支持导出HTML，只是还原效果上有点差，出现了格式混乱。

![PDF_TO_HTML](/Users/iminder/Downloads/PDF_TO_HTML.png)

#### 转成图片

转成图片这种方式实现简单，可以用作简单预览使用，但是缺点也很明显，无法做到查找复制。微云Web使用的架平的在线预览方案就是这种。

<https://sz-preview-ftn.weiyun.com:8443/ftn_doc_abstract/0db02dd92c3a40cca9b2abe5b020dfca6d5230b0/0db02dd92c3a40cca9b2abe5b020dfca6d5230b0_1.jpg>

#### 转成图片+文本

这种方案是为了实现PDF文本查找，复制等能力，在图片的基础上，增加了文本内容区域来综合渲染，附件提供了一个Demo简单演示如何实现这种效果。谷歌采用了类似方式实现预览，不过有点区别的是，谷歌将PDF每一页都渲染成了图片，文本区域只用来实现查找、复制等。高亮的实现原理是利用div对特定文本区域提供一个带有透明背景色的区域来实现的。

![ 谷歌pdf预览方案](/Users/iminder/Downloads/谷歌pdf预览方案.png)

优点是能完美做到一比一还原展示PDF内容，对一些纯图片的PDF也可以很完美的支持。

缺点就是文本选择实现复制能力受限于分离的PDF文本粒度，不能做到自由选择。

#### Canvas绘制

这是一种前端解决方案，利用Canvas绘制实现，优秀的代表是PDF.js。

PDF.js 是Mozilla开源的一套专门为HTML5实现的在线观看PDF的js框架，无论是PC还是移动设备，现在对H5都已经支持的很好，因此PDF.js是一套很好的选择。PDF.js 基于cavas来实现pdf内容的渲染。

![PDF.js架构](/Users/iminder/Downloads/PDF.js架构.png)

PDF.js 整体工程架构如图，其中core模块负责PDF文件的解析，是核心模块，display模块是针对core模块的封装，提供更友好的API共上层调用。而view是负责展示的模块，一般仅仅在这一层对PDF.js来做定制。

PDF.js在worker thread来解析PDF文件，使用promise来实现异步回调。所有这些工作都是在前端完成的。

优点：经过测试，PDF.js针对大部分PDF解析无论从还原效果和解析性能上都有不错的表现。并且基于H5的cavas标签来绘制，在移动设备上也能很好的支持。PDF功能支持较为完善，PDF目录、缩略图等功能均有支持。解析过程在client侧，不需要服务器进行解析渲染。

缺点：无法对PDF编辑，一些高亮，标注等能力无法实现。大文件下载后解析可能较慢。

PS： 百度网盘也是基于PDF.js做的预览方案。

### 腾讯文档PDF预览方案

腾讯文档要实现PDF的导入，预览，查找，复制等功能。经过综合几种对比，选择基于PDF.js来实现。

对前端来说，可以基于PDF.js的View模块来做定制，或者自己利用Display模块来实现页面效果。

对后台来说只需要考虑PDF文件的存储以及解析PDF文本内容，以便在腾讯文档目录页进行查找内容操作。后台需要考虑的一个问题就是当PDF较大时，需要对PDF文件做分页处理，前面介绍了PDF由于格式问题不能做流式解析，因此，可以将叫大PDF做分页处理，返回给前端较小切片来实现快速展示效果。

下面是一个简单的时序图：

![腾讯文档PDF预览方案时序图效果](/Users/iminder/Downloads/腾讯文档PDF预览方案时序图.png)



1. 用户导入PDF后，后台在创建成功文件信息返回给前端，首次前端可以不依赖后台数据进行解析预览。甚至可以在后台返回文件信息之前进行解析，等文件信息返回后直接展示，加快了预览速度。后台根据文件大小决定是否需要做分页存储处理。

2. 用户打开已经目录中已上传PDF，后台根据文件大小决定是返回完整文件还是文件分片，前端拿到地址后开始下载解析。

3. 分享给其他用户的链接，预览方式同2.

   

##### 文本选择高亮

针对PDF腾讯文档目录页的查找操作，依赖后台跑的PDF内容数据来处理。而对预览详情页的查找高亮操作，则通过将canvas renderContext在textLayer上渲染来实现。下面是简单的实现：

```
page.render(renderContext).then(() => { //canvas
          return page.getTextContent();
        }).then((textContent) => {
          // 创建文本图层div
          const textLayerDiv = document.getElementById('textlayer');
          textLayerDiv.setAttribute('class', 'textLayer');
          // 创建新的TextLayerBuilder实例
          var textLayer =  pdfjsLib.renderTextLayer({
            textContent: textContent,
            container: textLayerDiv,
            viewport: viewport
          });
          textLayer._render();
          //textLayer.setTextContent(textContent);
          //textLayer.render();
        });
```



##### 目录/缩略图

依赖PDF.js 返回的目录和缩略图数据来实现目录和缩略图跳转效果。

![目录缩略图功能](/Users/iminder/Downloads/目录缩略图功能.png)

##### 其他功能

跳转到指定页，打印，缩放等能力，甚至PDF全屏演示能力。作为后续预览能力的补充，均可以通过定制实现。可以参考记忆PDF.js 搭建的一个体验demo来看下。

<http://119.28.47.217/web/viewer.html>



参考文档：

<https://www.jianshu.com/p/51eb811ba935>

<https://github.com/mozilla/pdf.js/>

https://github.com/coolwanglu/pdf2htmlEX

https://github.com/coolwanglu/pdf2htmlEX/wiki/Comparison#fn2