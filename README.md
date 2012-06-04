# Needs estimation

* __Content/day__:

TODO


# Setup

TODO


# Language detector libraries


## [whatlanguage](https://github.com/peterc/whatlanguage)

* __Available languages:__ dutch, english, farsi, french, german, italian, pinyin, portuguese, russian, spanish, swedish

A more comprehensive list on [ealdent fork](https://github.com/ealdent/whatlanguage).



## [language_detector](https://github.com/moeffju/language_detector)

* __Technical reference:__ [Evaluation of language identification methods](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.93.720&rep=rep1&type=pdf)

* __Detection method:__ ngrams

* __Training corpus:__ from Wikipedia

### FM model

* built from scratch texts included with gem

* __Available languages:__ arabic, bulgarian, czech, danish, german, greek, english, estonian, spanish, farsi, finnish, french, irish, hebrew, hindi, croatian, italian, japanese, korean, hungarian, turkish, dutch, norwegian, polish, portuguese, romanian, russian, slovenian, swedish, thai, ukraninan, vietnamese, chinese

### TC model

* textcat ngram database (26 languages based on European corpus)

* __Available languages:__



## [unsupervised_language_identification](https://github.com/echen/unsupervised-language-identification)

* build for tweets detection

* __Technical reference:__ [http://blog.echen.me/2011/05/01/unsupervised-language-detection-algorithms/](http://blog.echen.me/2011/05/01/unsupervised-language-detection-algorithms/)

* __Available languages:__ du, en, sp








# Language detector web services


## [Google Translate API](https://developers.google.com/translate/v2/using_rest#detect-language)

* __Price__: $20 per 1M chars
* __Available languages:__ tons

### Library

* [to_lang](https://github.com/jimmycuadra/to_lang)

* [google_api_ruby_client](https://code.google.com/p/google-api-ruby-client/#Google_Translate_API)



## [AlchemyAPI](http://www.alchemyapi.com/api/lang/textc.html)

* __Demo:__ [web interface](http://www.alchemyapi.com/api/lang/) 

* __Price__: [not displayed](http://www.alchemyapi.com/products/)

* __Available languages:__ [95+ european, asian](http://www.alchemyapi.com/api/lang/langs.html)



## [detectlanguage](http://ws.detectlanguage.com/0.2/detect?key=demo&q=ce%20mai%20faci)

* __Demo__: [api call](http://ws.detectlanguage.com/0.2/detect?key=demo&q=ce%20mai%20faci)

* __Price__: 5k requests, 1MB/day is free, 100k requests, 20MB/day is $5/month

* __Available languages:__ 96 languages

### Library
[wtf_language](https://github.com/nashby/wtf_lang)




# Theoretical references

* [bloom filters](http://blog.rapleaf.com/dev/2007/09/05/bloomfilter/)

