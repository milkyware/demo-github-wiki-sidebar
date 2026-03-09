# GitHub Wiki Sidebar

This action generates a sidebar for your GitHub wiki.

## Usage

```yaml
- name: Generate wiki sidebar
  uses: milkyware/actions/github-wiki-sidebar@main
  with:
    wiki-path: './wiki'
    output-file: '_Sidebar.md'
    root-file-name: 'Home'
```

## Inputs

| Name               | Description                                                        | Default                               | Required |
| ------------------ | ------------------------------------------------------------------ | ------------------------------------- | -------- |
| `wiki-path`        | The path to the GitHub wiki repository.                            |                                       | `true`   |
| `output-file`      | The name of the output file.                                       | `_Sidebar.md`                         | `false`  |
| `root-file-name`   | The name for the root/home page link.                              | `Home`                                | `false`  |
| `image-extensions` | A comma-separated list of image extensions to ignore.              | `.jpg,.jpeg,.png,.gif,.svg,.bmp`      | `false`  |
| `link-prefix`      | A prefix to add to all links.                                      | `''`                                  | `false`  |
| `link-suffix`      | A suffix to add to all links.                                      | `''`                                  | `false`  |
| `exclude`          | A comma-separated list of files to exclude.                        | `''`                                  | `false`  |
| `order`            | A comma-separated list of files to define their order.             | `''`                                  | `false`  |
| `use-page-title`   | A boolean to indicate whether to use the page title from the file content. | `false`                             | `false`  |
| `dry-run`          | A boolean to indicate whether to actually write the file or just print the output. | `false`                             | `false`  |

## Outputs

| Name                | Description                      |
| ------------------- | -------------------------------- |
| `sidebar-content`   | The generated sidebar content.   |

## Example Workflow

```yaml
name: 'Generate Wiki Sidebar'

on:
  push:
    branches:
      - main
    paths:
      - 'wiki/**'

jobs:
  generate-sidebar:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
        with:
          repository: ${{ github.repository }}.wiki
          path: wiki

      - name: Generate wiki sidebar
        uses: milkyware/actions/github-wiki-sidebar@main
        with:
          wiki-path: './wiki'

      - name: Commit and push changes
        run: |
          cd wiki
          git config --global user.name 'github-actions[bot]'
          git config --global user.email 'github-actions[bot]@users.noreply.github.com'
          git add _Sidebar.md
          git commit -m "docs: generate wiki sidebar" || exit 0
          git push
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
