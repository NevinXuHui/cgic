---
url: https://zhuanlan.zhihu.com/p/136410759
title: 使用 Go 语言完成 HTTP 文件上传与下载
date: 2023-04-04 14:49:07
tag: 
banner: "https://pic1.zhimg.com/v2-d48cab84c20a5bb5df4748295f9ab384_r.jpg?source=172ae18b"
banner_icon: 🔖
---
最近我使用 Go 语言完成了一个正式的 web 应用，有一些方面的问题在使用 Go 开发 web 应用过程中比较重要。过去，我将 web 开发作为一项职业并且把使用不同的语言和范式开发 web 应用作为一项爱好，因此对于 web 开发领域有一些心得体会。

总的来说，我喜欢使用 Go 语言进行 web 开发，尽管开始一段时间需要去适应它。Go 语言有一些坑，但是正如本篇文章中所要讨论的文件上传与下载，Go 语言的标准库与内置函数，使得开发是种愉快的体验。

在接下来的几篇文章中，我将重点讨论我在 Go 中编写生产级 Web 应用程序时遇到的一些问题，特别是关于身份验证 / 授权的问题。

这篇文章将展示 HTTP 文件上传和下载的基本示例。我们将一个有 `type` 文本框和一个 `uploadFile` 上传框的 HTML 表单作为客户端。

让我们来看下 Go 语言中是如何解决这种在 web 开发中随处可见的问题的。

## **代码示例**

首先，我们在服务器端设定两个路由，`/upload` 用于文件上传， `/files/*` 用于文件下载。

```
const maxUploadSize = 2 * 1024 * 2014 // 2 MB 
const uploadPath = "./tmp"

func main() {
    http.HandleFunc("/upload", uploadFileHandler())

    fs := http.FileServer(http.Dir(uploadPath))
    http.Handle("/files/", http.StripPrefix("/files", fs))

    log.Print("Server started on localhost:8080, use /upload for uploading files and /files/{fileName} for downloading files.")
    log.Fatal(http.ListenAndServe(":8080", nil))
}


```

我们还将要上传的目标目录，以及我们接受的最大文件大小定义为常量。注意这里，整个文件服务的概念是如此的简单 —— 我们仅使用标准库中的工具，使用 `http.FileServe` 创建一个 HTTP 处理程序，它将使用 `http.Dir(uploadPath)` 提供的目录来上传文件。

现在我们只需要实现 `uploadFileHandler`。

这个处理程序将包含以下功能：

*   验证文件最大值
*   从请求验证文件和 POST 参数
*   检查所提供的文件类型（我们只接受图像和 PDF）
*   创建一个随机文件名
*   将文件写入硬盘
*   处理所有错误，如果一切顺利返回成功消息

第一步，我们定义处理程序:

```
func uploadFileHandler() http.HandlerFunc {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {


```

然后，我们使用 `http.MaxBytesReader` 验证文件大小，当文件大小大于设定值时它将返回一个错误。错误将被一个助手程序 `renderError` 进行处理，它返回错误信息及对应的 HTTP 状态码。

```
    r.Body = http.MaxBytesReader(w, r.Body, maxUploadSize)
    if err := r.ParseMultipartForm(maxUploadSize); err != nil {
        renderError(w, "FILE_TOO_BIG", http.StatusBadRequest)
        return
    }


```

如果文件大小验证通过，我们将检查并解析表单参数类型和上传的文件，并读取文件。在本例中，为了清晰起见，我们不使用花哨的 `io.Reader` 和 `io.Writer` 接口，我们只是简单的将文件读取到一个字节数组中，这点我们后面会写到。

```
    fileType := r.PostFormValue("type")
    file, _, err := r.FormFile("uploadFile")
    if err != nil {
        renderError(w, "INVALID_FILE", http.StatusBadRequest)
        return
    }
    defer file.Close()
    fileBytes, err := ioutil.ReadAll(file)
    if err != nil {
        renderError(w, "INVALID_FILE", http.StatusBadRequest)
        return
    }


```

现在我们成功的验证了文件的大小，并且读取了文件，接下来我们该检验文件的类型了。一种廉价但是并不安全的方式，只检查文件扩展名，并相信用户没有改变它，但是对于一个正式的项目来讲不应该这么做。

幸运的是，Go 标准库提供给我们一个 `http.DetectContentType` 函数，这个函数基于 `mimesniff` 算法，只需要读取文件的前 512 个字节就能够判定文件类型。

```
    filetype := http.DetectContentType(fileBytes)
    if filetype != "image/jpeg" && filetype != "image/jpg" &&
        filetype != "image/gif" && filetype != "image/png" &&
        filetype != "application/pdf" {
        renderError(w, "INVALID_FILE_TYPE", http.StatusBadRequest)
        return
    }


```

在实际应用程序中，我们可能会使用文件元数据做一些事情，例如将其保存到数据库或将其推送到外部服务——以任何方式，我们将解析和操作元数据。这里我们创建一个随机的新名字（这在实践中可能是一个 UUID）并将新文件名记录下来。

```
    fileName := randToken(12)
    fileEndings, err := mime.ExtensionsByType(fileType)
    if err != nil {
        renderError(w, "CANT_READ_FILE_TYPE", http.StatusInternalServerError)
        return
    }
    newPath := filepath.Join(uploadPath, fileName+fileEndings[0])
    fmt.Printf("FileType: %s, File: %s\n", fileType, newPath)


```

马上就大功告成了，只剩下一个关键步骤 - 写文件。如上文所提到的，我们只需要复制读取的二进制文件到一个新创建的名为 `newFile` 的文件处理程序里。

如果所有部分都没问题，我们给用户返回一个 `SUCCESS` 信息。

```
    newFile, err := os.Create(newPath)
    if err != nil {
        renderError(w, "CANT_WRITE_FILE", http.StatusInternalServerError)
        return
    }
    defer newFile.Close()
    if _, err := newFile.Write(fileBytes); err != nil {
        renderError(w, "CANT_WRITE_FILE", http.StatusInternalServerError)
        return
    }
    w.Write([]byte("SUCCESS"))


```

这样可以了. 你可以对这个简单的例子进行测试，使用虚拟的文件上传 HTML 页面，cURL 或者工具例如 **[postman](https://www.getpostman.com/)**。

这里是完整的代码示例 **[这里](https://github.com/zupzup/golang-http-file-upload-download)**

## **结论**

这是又一个证明了 Go 如何允许用户为 web 编写简单而强大的软件，而不必像处理其他语言和生态系统中固有的无数抽象层。

在接下来的篇幅中，我将展示一些在我第一次使用 Go 语言编写正式的 web 应用中其他细节，敬请期待。；）

// 根据 reddit 用户 `lstokeworth` 的反馈对部分代码进行了修改。谢谢

![](1680590947448.png)

### **资源**

**[完整代码示例](https://github.com/zupzup/golang-http-file-upload-download)**

首发于: [https://studygolang.com/articles/12340](https://studygolang.com/articles/12340)

作者：**[zupzup](https://zupzup.org/about/)**

译者：**[fengchunsgit](https://github.com/fengchunsgit)**

校对：**[polaris1119](https://github.com/polaris1119)**

本文由 **[GCTT](https://github.com/studygolang/GCTT)** 原创编译，**[Go 语言中文网](https://studygolang.com/articles/12340)** 荣誉推出

了解更多资讯，欢迎关注微信公众号：Go 语言中文网