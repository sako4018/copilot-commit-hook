# copilot-commit-hook

Автоматично съобщение за `git commit`. Пишеш само:

```
git add .
git commit
git push
```

а съобщението се измисля само, като [Conventional Commit](https://www.conventionalcommits.org/), например:

```
feat(weather): add a screen that displays the forecast
```

Съобщението се генерира от [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli) по това, което е променено (`git diff --cached`). Няма екран за редактиране, комитът минава веднага.

## Какво ти трябва

- macOS (тествано) или Linux, `git` и `perl` (идват с macOS)
- Node.js 22 или по-нов
- GitHub акаунт с Copilot

## Инсталиране

```
npm install -g @github/copilot
copilot login

git clone https://github.com/sako4018/copilot-commit-hook.git
cd copilot-commit-hook
sh install.sh
```

`install.sh` копира два файла в `~/.config/git/` и задава две глобални git настройки (`core.hooksPath` и `core.editor`), така че да работи във всички твои проекти. Ако вече имаш такива настройки, не ги презаписва, а ти казва.

## Как работи

- `hooks/prepare-commit-msg` е git hook. Git го пуска точно преди да се запише съобщението. Праща промените (до 12 000 символа) към Copilot и записва отговора като съобщение.
- `hooks/auto-editor` казва на git да приеме готовото съобщение без да отваря екран. Ако съобщението е празно (няма интернет, грешка, свършен лимит), отваря `nano`, за да го напишеш сам.

Правилата за съобщенията (типове, дължина, език) са написани в текста вътре в `hooks/prepare-commit-msg`. Типове: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. Може да ги промениш там.

## Нещо не ти хареса?

- Поправи последния комит (само ако още не си го качил с `git push`):
  ```
  git commit --amend -m "ново съобщение"
  ```
- Напиши сам съобщението за един комит: `git commit -m "моето съобщение"`. Hook-ът не го пипа.
- Пропусни hook-а за един комит: `git -c core.hooksPath=/dev/null commit`

Hook-ът не пипа `-m`, `--amend`, merge, squash и rebase, и не прави нищо, ако няма добавени промени (`git add`). Ако нещо се обърка, комитът не се блокира.

## Лимит

Всеки комит е една заявка към Copilot и се брои от твоя Copilot план. При малки комити лимитът трудно се стига. Ако свърши, съобщението остава празно и се отваря `nano`.

## Премахване

```
sh uninstall.sh
```

Връща git към обикновеното му поведение. Copilot CLI остава инсталиран; ако не го искаш: `npm uninstall -g @github/copilot`.

## Какво е важно да знаеш

- Към Copilot се пращат промените от комита. Не комитвай тайни файлове и ключове, не само заради това.
- В скриптовете няма ключове и лични данни. Входът се пази от Copilot CLI.
