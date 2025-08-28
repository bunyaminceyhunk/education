# education
Winchoos Dashboard (static)

Calistirma

1) Yerel sunucu ile acmak icin bir http server kullanin. Ornek:

```bash
npx http-server -p 5173
```

Ardindan tarayicida `http://localhost:5173` adresine gidin.

Notlar

- Tema renkleri: Arka plan `#161719`, Ana `#3EE15B`, Ikincil `#06413E`, Gri `#656965`, Siyah `#0A0A0A`, Acik gri `#AAAAAA`.
- Tasarim mobil ve tablet icin responsive yapilandirildi. Sol menuyu mobilde ustteki menuden acip kapatabilirsiniz.

Yayina Alma (Google'da gorunur yapmak)

Secenek A — GitHub Pages

1) Bu dizini bir GitHub reposuna yukleyin ve ana branch'i `main` olarak ayarlayin.
2) Actions sekmesinde "Deploy to GitHub Pages" workflow'unun calistigini gorun. Ilk push'ta otomatik devreye girer.
3) Settings → Pages bolumunde domain'i gorursunuz. Ornek: `https://kullaniciadi.github.io/repo-adi/`.
4) Google'a bildirmek icin bu URL'yi Search Console'a ekleyin ve dizin istegi gonderin.

Secenek B — Vercel

1) `https://vercel.com/new` uzerinden repoyu secin. Proje statik oldugu icin build ayari gerekmiyor.
2) Deploy sonrasi olusan URL'yi custom domain ile baglayabilirsiniz.
3) Search Console'a domain'i ekleyip indexleme isteyin.

SEO / Indexleme Ipuclari

- `robots.txt` ve `sitemap.xml` hazirdir. Alan adi altinda otomatik erisilebilir olacaktir.
- `index.html` icindeki `title`, `meta description` ve `og:` etiketlerini kendi markaniza gore guncelleyebilirsiniz.