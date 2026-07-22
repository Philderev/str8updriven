const fs=require('fs'),path=require('path');
const dir=path.join(__dirname,'export');
const head=`<style data-sud-local-fonts>
@font-face{font-family:'Archivo';font-style:normal;font-weight:500 900;font-display:swap;src:url('./assets/fonts/archivo-latin.woff2') format('woff2')}
@font-face{font-family:'Space Grotesk';font-style:normal;font-weight:400 700;font-display:swap;src:url('./assets/fonts/space-grotesk-latin.woff2') format('woff2')}
</style>
<link rel="icon" href="./favicon.ico" sizes="any">
<link rel="icon" type="image/png" sizes="32x32" href="./assets/favicon-32.png">
<link rel="icon" type="image/png" sizes="16x16" href="./assets/favicon-16.png">
<link rel="apple-touch-icon" sizes="180x180" href="./assets/apple-touch-icon.png">
<link rel="manifest" href="./site.webmanifest">
<meta name="theme-color" content="#0a0a0c">
<meta name="msapplication-TileColor" content="#0a0a0c">
<meta name="msapplication-config" content="./browserconfig.xml">`;
for(const name of fs.readdirSync(dir).filter(n=>n.endsWith('.html'))){
 const file=path.join(dir,name);let outer=fs.readFileSync(file,'utf8');
 const m=outer.match(/(<script type="__bundler\/template">\s*)("[^\r\n]*")(\s*<\/script>)/);
 if(m){let t=JSON.parse(m[2]);t=t.replace(/\s*<link rel="preconnect" href="https:\/\/fonts\.googleapis\.com">\s*<style>\/\* vietnamese \*\/[\s\S]*?<\/style>/,'');if(!t.includes('data-sud-local-fonts'))t=t.replace('</helmet>',head+'</helmet>');const enc=JSON.stringify(t).replace(/<\//g,'<\\u002F');outer=outer.slice(0,m.index)+m[1]+enc+m[3]+outer.slice(m.index+m[0].length)}
 else if(!outer.includes('data-sud-local-fonts'))outer=outer.replace('</head>',head+'</head>');
 fs.writeFileSync(file,outer);console.log('wired',name);
}
