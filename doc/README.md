# Convertendo SVN to GIT

Utilize a imagem docker `amixsi/svn2git` para obter os comandos necessários para conversão.

```sh
docker run --rm -it -v $(pwd):/wrk "$HOME":/keys amixsi/svn2git
# Add keys to ssh-agent
ssh-add /keys/id_rsa
```

## Caso de uso

Projeto RNCRM

## Migrando as dependências externas

Aplicar o mesmo processo abaixo para cada `submodulo`:

- mdr svn+ssh://amsxp02/Work/prj/mdr/branches/rncrm
- logging svn+ssh://amsxp02/Work/prj/php-pkg-logging/trunk/logging
- exception svn+ssh://amsxp02/Work/prj/php-pkg-exception/trunk/exception
- xml svn+ssh://amsxp02/Work/prj/php-pkg-xml/trunk/xml

```sh
# Variáveis necessárias
AUTHORS=/wrk/authors.txt
SVN_URL_ROOT=svn+ssh://amsxp02/Work/prj/mdr

# Gerar arquivo de autores para ser convertido para o layout do git
svn_generate_authors
vi /wrk/authors.txt
svn_git
cd /wrk/repo
git remote add origin git@gitlab.oxxys.lan/amixsi/mdr.git
cp .git/refs/remotes/origin/* .git/refs/heads/
git push -u origin --all
git push origin --tags
```

## Migrando o projeto e adicionando os submodulos

```sh
# Variáveis necessárias
AUTHORS=/wrk/authors.txt
SVN_URL_ROOT=svn+ssh://edison@amsxp02/Work/prj/rncrm

# Gerar arquivo de autores para ser convertido para o layout do git
svn_generate_authors
```

Modificar `/wrk/authors.txt`

```diff
--- /wrk/authors.txt.orig
+++ /wrk/authors.txt
@@ -1,2 +1,2 @@
-edison = edison <edison>
-root = root <root>
+edison = Edison E. Abreu <edison@amixsi.com.br>
+root = Edison E. Abreu <edison@amixsi.com.br>
```

```sh
# Converte SVN to GIT into /wrk/repo
svn_git
cd /wrk/repo
git submodule add -b rncrm git@gitlab.oxxys.lan:amixsi/mdr.git mdr
git submodule add git@gitlab.oxxys.lan:amixsi/php-pkg-logging.git lib/php-pkg-logging
git submodule add git@gitlab.oxxys.lan:amixsi/php-pkg-exception.git lib/php-pkg-exception
git submodule add git@gitlab.oxxys.lan:amixsi/php-pkg-xml.git lib/php-pkg-xml
cd lib
ln -s php-pkg-logging/logging
ln -s php-pkg-exception/exception
ln -s php-pkg-xml/xml
cp .git/refs/remotes/origin/* .git/refs/heads/
git push -u origin --all
git push origin --tags
```

## Adicionando mensagem aos usuários do repositório SVN migrado

Crie o *hook* `repository/hooks/pre-commit`:

```sh
#!/bin/sh
echo "No more commit here - this is an archive branch" 1>&2
exit 1
```

> [Referência](https://stackoverflow.com/questions/2411122/how-to-freeze-entire-svn-repository-to-make-it-read-only)
