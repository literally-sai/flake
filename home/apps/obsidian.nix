{ ... }:
{
  programs.obsidian = {
    enable = true;

    defaultSettings = {
      appearance = {
        theme = "obsidian";
        accentColor = "#d0a028";
        baseFontSize = 16;
        baseFontSizeAction = true;
        showViewHeader = true;
        showRibbon = true;
        nativeMenus = false;
      };

      app = {
        showInlineTitle = true;
        focusNewTab = true;
        defaultViewMode = "source";
        livePreview = false;
        readableLineLength = true;
        strictLineBreaks = true;
        propertiesInDocument = "visible";
        foldHeading = true;
        foldIndent = true;
        showLineNumber = true;
        showIndentGuide = true;
        rightToLeft = false;
        spellcheck = true;
        autoPairBrackets = true;
        autoPairMarkdown = true;
        smartIndentList = true;
        useTab = true;
        tabSize = 2;
        autoConvertHtml = true;
        vimMode = true;
        promptDelete = false;
        trashOption = "local";
        alwaysUpdateLinks = false;
        newFileLocation = "current";
        newLinkFormat = "relative";
        useMarkdownLinks = true;
        showUnsupportedFiles = true;
        attachmentFolderPath = "./";
      };

      corePlugins = [
        "backlink"
        "bookmarks"
        "canvas"
        "command-palette"
        "daily-notes"
        "editor-status"
        "file-explorer"
        "file-recovery"
        "global-search"
        "graph"
        "markdown-importer"
        "note-composer"
        "outgoing-link"
        "outline"
        "page-preview"
        "properties"
        "publish"
        "random-note"
        "slash-command"
        "slides"
        "switcher"
        "tag-pane"
        "templates"
        "word-count"
        "workspaces"
      ];
    };

    vaults."notes".enable = true;
  };
}
