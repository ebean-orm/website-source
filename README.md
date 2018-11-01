Website
======================

Source for the website for Ebean ORM.


## How to build the website


### 1. Clone website-source repo

- git clone git@github.com:ebean-orm/website-source.git


### 2. Make a destination directory

```bash
mkdir website-dest
```

### 2. Download avaje-website-generator-2.1.2.jar

- download https://repo1.maven.org/maven2/org/avaje/avaje-website-generator/2.1.2/avaje-website-generator-2.1.2.jar




### 3. run the website generator

```bash
java -jar avaje-website-generator-2.1.2.jar -s website-source/ -d website-dest/
```

This website generator will:
- generate content into website-dest
- continue to run (until CTRL-C) watching the source directory
- When any source file changes it will re-generate the changed content


### 4. setup nginx to serve the website-dest directory

For example:
```none

root /home/rob/work/website-dest;

index index.html index.htm;

server_name _;

location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri.html $uri/ =404;
}
```


