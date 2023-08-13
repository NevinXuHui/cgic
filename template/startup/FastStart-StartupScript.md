<%*
fastStart = async (filename, delayInSecond) => {
    if (tp.file.exists(filename)) {
        const f = tp.file.find_tfile(filename);
        let plugins = (await app.vault.read(f)).split(/\r?\n/);
        setTimeout(async () => {
            plugins.forEach(async (p) => await app.plugins.enablePlugin(p))
        }, delayInSecond * 1000)
    }
}
//手机端需要启动的插件，手机端与电脑端开启需要一一对应。通过加上//注释掉，或删除开启
//await fastStart("FastStart-Plugins-mobile", 2)
//电脑端需要启动的插件
await fastStart("FastStart-Plugins-ShortDelay", 2)
await fastStart("FastStart-Plugins-LongDelay", 6)
%>