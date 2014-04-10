function MediumEditor(elements, options) {
    'use strict';
    return this.init(elements, options);
}

if (typeof module === 'object') {
    module.exports = MediumEditor;
}

(function (window, document) {
    'use strict';

    function extend(b, a) {
        var prop;
        if (b === undefined) {
            return a;
        }
        for (prop in a) {
            if (a.hasOwnProperty(prop) && b.hasOwnProperty(prop) === false) {
                b[prop] = a[prop];
            }
        }
        return b;
    }

    // http://stackoverflow.com/questions/5605401/insert-link-in-contenteditable-element
    // by Tim Down
    function saveSelection() {
        var i,
            len,
            ranges,
            sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            ranges = [];
            for (i = 0, len = sel.rangeCount; i < len; i += 1) {
                ranges.push(sel.getRangeAt(i));
            }
            return ranges;
        }
        return null;
    }

    function restoreSelection(savedSel) {
        var i,
            len,
            sel = window.getSelection();
        if (savedSel) {
            sel.removeAllRanges();
            for (i = 0, len = savedSel.length; i < len; i += 1) {
                sel.addRange(savedSel[i]);
            }
        }
    }

    // http://stackoverflow.com/questions/1197401/how-can-i-get-the-element-the-caret-is-in-with-javascript-when-using-contentedi
    // by You
    function getSelectionStart() {
        var node = document.getSelection().anchorNode,
            startNode = (node && node.nodeType === 3 ? node.parentNode : node);
        return startNode;
    }

    // http://stackoverflow.com/questions/4176923/html-of-selected-text
    // by Tim Down
    function getSelectionHtml() {
        var i,
            html = '',
            sel,
            len,
            container;
        if (window.getSelection !== undefined) {
            sel = window.getSelection();
            if (sel.rangeCount) {
                container = document.createElement('div');
                for (i = 0, len = sel.rangeCount; i < len; i += 1) {
                    container.appendChild(sel.getRangeAt(i).cloneContents());
                }
                html = container.innerHTML;
            }
        } else if (document.selection !== undefined) {
            if (document.selection.type === 'Text') {
                html = document.selection.createRange().htmlText;
            }
        }
        return html;
    }

    MediumEditor.prototype = {
        defaults: {
            allowMultiParagraphSelection: true,
            anchorInputPlaceholder: 'Paste or type a link',
            buttons: ['bold', 'italic', 'underline', 'anchor', 'header1', 'header2', 'quote'],
            buttonLabels: false,
            delay: 0,
            diffLeft: 0,
            diffTop: -10,
            disableReturn: false,
            disableDoubleReturn: false,
            disableToolbar: false,
            firstHeader: 'h3',
            forcePlainText: true,
            placeholder: 'Type your text',
            secondHeader: 'h4',
            targetBlank: false,
            anchorPreviewHideDelay: 500
        },

        // http://stackoverflow.com/questions/17907445/how-to-detect-ie11#comment30165888_17907562
        // by rg89
        isIE: ((navigator.appName === 'Microsoft Internet Explorer') || ((navigator.appName === 'Netscape') && (new RegExp('Trident/.*rv:([0-9]{1,}[.0-9]{0,})').exec(navigator.userAgent) !== null))),

        init: function (elements, options) {
            this.elements = typeof elements === 'string' ? document.querySelectorAll(elements) : elements;
            if (this.elements.nodeType === 1) {
                this.elements = [this.elements];
            }
            if (this.elements.length === 0) {
                return;
            }
            this.parentElements = ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'pre'];
            this.id = document.querySelectorAll('.medium-editor-toolbar').length + 1;
            this.options = extend(options, this.defaults);
            return this.setup();
        },

        setup: function () {
            this.isActive = true;
            this.initElements()
                .bindSelect()
                .bindPaste()
                .setPlaceholders()
                .bindWindowActions();
        },

        initElements: function () {
            var i,
                addToolbar = false;
            for (i = 0; i < this.elements.length; i += 1) {
                this.elements[i].setAttribute('contentEditable', true);
                if (!this.elements[i].getAttribute('data-placeholder')) {
                    this.elements[i].setAttribute('data-placeholder', this.options.placeholder);
                }
                this.elements[i].setAttribute('data-medium-element', true);
                this.bindParagraphCreation(i).bindReturn(i).bindTab(i).bindAnchorPreview(i);
                if (!this.options.disableToolbar && !this.elements[i].getAttribute('data-disable-toolbar')) {
                    addToolbar = true;
                }
            }
            // Init toolbar
            if (addToolbar) {
                this.initToolbar()
                    .bindButtons()
                    .bindAnchorForm();
            }
            return this;
        },

        serialize: function () {
            var i,
                elementid,
                content = {};
            for (i = 0; i < this.elements.length; i += 1) {
                elementid = (this.elements[i].id !== '') ? this.elements[i].id : 'element-' + i;
                content[elementid] = {
                    value: this.elements[i].innerHTML.trim()
                };
            }
            return content;
        },

        bindParagraphCreation: function (index) {
            var self = this;
            this.elements[index].addEventListener('keyup', function (e) {
                var node = getSelectionStart(),
                    tagName;
                if (node && node.getAttribute('data-medium-element') && node.children.length === 0 && !(self.options.disableReturn || node.getAttribute('data-disable-return'))) {
                    document.execCommand('formatBlock', false, 'p');
                }
                if (e.which === 13) {
                    node = getSelectionStart();
                    tagName = node.tagName.toLowerCase();
                    if (!(self.options.disableReturn || this.getAttribute('data-disable-return')) &&
                        tagName !== 'li' && !self.isListItemChild(node)) {
                        if (!e.shiftKey) {
                            document.execCommand('formatBlock', false, 'p');
                        }
                        if (tagName === 'a') {
                            document.execCommand('unlink', false, null);
                        }
                    }
                }
            });
            return this;
        },

        isListItemChild: function (node) {
            var parentNode = node.parentNode,
                tagName = parentNode.tagName.toLowerCase();
            while (this.parentElements.indexOf(tagName) === -1 && tagName !== 'div') {
                if (tagName === 'li') {
                    return true;
                }
                parentNode = parentNode.parentNode;
                if (parentNode && parentNode.tagName) {
                    tagName = parentNode.tagName.toLowerCase();
                } else {
                    return false;
                }
            }
            return false;
        },

        bindReturn: function (index) {
            var self = this;
            this.elements[index].addEventListener('keypress', function (e) {
                if (e.which === 13) {
                    if (self.options.disableReturn || this.getAttribute('data-disable-return')) {
                        e.preventDefault();
                    } else if (self.options.disableDoubleReturn || this.getAttribute('data-disable-double-return')) {
                        var node = getSelectionStart();
                        if (node && node.innerText === '\n') {
                            e.preventDefault();
                        }
                    }
                }
            });
            return this;
        },

        bindTab: function (index) {
            this.elements[index].addEventListener('keydown', function (e) {
                if (e.which === 9) {
                    // Override tab only for pre nodes
                    var tag = getSelectionStart().tagName.toLowerCase();
                    if (tag === 'pre') {
                        e.preventDefault();
                        document.execCommand('insertHtml', null, '    ');
                    }
                }
            });
            return this;
        },

        buttonTemplate: function (btnType) {
            var buttonLabels = this.getButtonLabels(this.options.buttonLabels),
                buttonTemplates = {
                    'bold': '<li><button class="medium-editor-action medium-editor-action-bold" data-action="bold" data-element="b">' + buttonLabels.bold + '</button></li>',
                    'italic': '<li><button class="medium-editor-action medium-editor-action-italic" data-action="italic" data-element="i">' + buttonLabels.italic + '</button></li>',
                    'underline': '<li><button class="medium-editor-action medium-editor-action-underline" data-action="underline" data-element="u">' + buttonLabels.underline + '</button></li>',
                    'strikethrough': '<li><button class="medium-editor-action medium-editor-action-strikethrough" data-action="strikethrough" data-element="strike"><strike>A</strike></button></li>',
                    'superscript': '<li><button class="medium-editor-action medium-editor-action-superscript" data-action="superscript" data-element="sup">' + buttonLabels.superscript + '</button></li>',
                    'subscript': '<li><button class="medium-editor-action medium-editor-action-subscript" data-action="subscript" data-element="sub">' + buttonLabels.subscript + '</button></li>',
                    'anchor': '<li><button class="medium-editor-action medium-editor-action-anchor" data-action="anchor" data-element="a">' + buttonLabels.anchor + '</button></li>',
                    'image': '<li><button class="medium-editor-action medium-editor-action-image" data-action="image" data-element="img">' + buttonLabels.image + '</button></li>',
                    'header1': '<li><button class="medium-editor-action medium-editor-action-header1" data-action="append-' + this.options.firstHeader + '" data-element="' + this.options.firstHeader + '">' + buttonLabels.header1 + '</button></li>',
                    'header2': '<li><button class="medium-editor-action medium-editor-action-header2" data-action="append-' + this.options.secondHeader + '" data-element="' + this.options.secondHeader + '">' + buttonLabels.header2 + '</button></li>',
                    'quote': '<li><button class="medium-editor-action medium-editor-action-quote" data-action="append-blockquote" data-element="blockquote">' + buttonLabels.quote + '</button></li>',
                    'orderedlist': '<li><button class="medium-editor-action medium-editor-action-orderedlist" data-action="insertorderedlist" data-element="ol">' + buttonLabels.orderedlist + '</button></li>',
                    'unorderedlist': '<li><button class="medium-editor-action medium-editor-action-unorderedlist" data-action="insertunorderedlist" data-element="ul">' + buttonLabels.unorderedlist + '</button></li>',
                    'pre': '<li><button class="medium-editor-action medium-editor-action-pre" data-action="append-pre" data-element="pre">' + buttonLabels.pre + '</button></li>',
                    'indent': '<li><button class="medium-editor-action medium-editor-action-indent" data-action="indent" data-element="ul">' + buttonLabels.indent + '</button></li>',
                    'outdent': '<li><button class="medium-editor-action medium-editor-action-outdent" data-action="outdent" data-element="ul">' + buttonLabels.outdent + '</button></li>'
                };
            return buttonTemplates[btnType] || false;
        },

        // TODO: break method
        getButtonLabels: function (buttonLabelType) {
            var customButtonLabels,
                attrname,
                buttonLabels = {
                    'bold': '<b>B</b>',
                    'italic': '<b><i>I</i></b>',
                    'underline': '<b><u>U</u></b>',
                    'superscript': '<b>x<sup>1</sup></b>',
                    'subscript': '<b>x<sub>1</sub></b>',
                    'anchor': '<b>#</b>',
                    'image': '<b>image</b>',
                    'header1': '<b>H1</b>',
                    'header2': '<b>H2</b>',
                    'quote': '<b>&ldquo;</b>',
                    'orderedlist': '<b>1.</b>',
                    'unorderedlist': '<b>&bull;</b>',
                    'pre': '<b>0101</b>',
                    'indent': '<b>&rarr;</b>',
                    'outdent': '<b>&larr;</b>'
                };
            if (buttonLabelType === 'fontawesome') {
                customButtonLabels = {
                    'bold': '<i class="fa fa-bold"></i>',
                    'italic': '<i class="fa fa-italic"></i>',
                    'underline': '<i class="fa fa-underline"></i>',
                    'superscript': '<i class="fa fa-superscript"></i>',
                    'subscript': '<i class="fa fa-subscript"></i>',
                    'anchor': '<i class="fa fa-link"></i>',
                    'image': '<i class="fa fa-picture-o"></i>',
                    'quote': '<i class="fa fa-quote-right"></i>',
                    'orderedlist': '<i class="fa fa-list-ol"></i>',
                    'unorderedlist': '<i class="fa fa-list-ul"></i>',
                    'pre': '<i class="fa fa-code fa-lg"></i>',
                    'indent': '<i class="fa fa-indent"></i>',
                    'outdent': '<i class="fa fa-outdent"></i>'
                };
            } else if (typeof buttonLabelType === 'object') {
                customButtonLabels = buttonLabelType;
            }
            if (typeof customButtonLabels === 'object') {
                for (attrname in customButtonLabels) {
                    if (customButtonLabels.hasOwnProperty(attrname)) {
                        buttonLabels[attrname] = customButtonLabels[attrname];
                    }
                }
            }
            return buttonLabels;
        },

        //TODO: actionTemplate
        toolbarTemplate: function () {
            var btns = this.options.buttons,
                html = '<ul id="medium-editor-toolbar-actions" class="medium-editor-toolbar-actions clearfix">',
                i,
                tpl;

            for (i = 0; i < btns.length; i += 1) {
                tpl = this.buttonTemplate(btns[i]);
                if (tpl) {
                    html += tpl;
                }
            }
            html += '</ul>' +
                '<div class="medium-editor-toolbar-form-anchor" id="medium-editor-toolbar-form-anchor">' +
                '    <input type="text" value="" placeholder="' + this.options.anchorInputPlaceholder + '">' +
                '    <a href="#">&times;</a>' +
                '</div>';
            return html;
        },

        initToolbar: function () {
            if (this.toolbar) {
                return this;
            }
            this.toolbar = this.createToolbar();
            this.keepToolbarAlive = false;
            this.anchorForm = this.toolbar.querySelector('.medium-editor-toolbar-form-anchor');
            this.anchorInput = this.anchorForm.querySelector('input');
            this.toolbarActions = this.toolbar.querySelector('.medium-editor-toolbar-actions');
            this.anchorPreview = this.createAnchorPreview();

            return this;
        },

        createToolbar: function () {
            var toolbar = document.createElement('div');
            toolbar.id = 'medium-editor-toolbar-' + this.id;
            toolbar.className = 'medium-editor-toolbar';
            toolbar.innerHTML = this.toolbarTemplate();
            document.body.appendChild(toolbar);
            return toolbar;
        },

        bindSelect: function () {
            var self = this,
                timer = '',
                i;

            this.checkSelectionWrapper = function (e) {

                // Do not close the toolbar when bluring the editable area and clicking into the anchor form
                if (e && self.clickingIntoArchorForm(e)) {
                    return false;
                }

                clearTimeout(timer);
                timer = setTimeout(function () {
                    self.checkSelection();
                }, self.options.delay);
            };

            document.documentElement.addEventListener('mouseup', this.checkSelectionWrapper);

            for (i = 0; i < this.elements.length; i += 1) {
                this.elements[i].addEventListener('keyup', this.checkSelectionWrapper);
                this.elements[i].addEventListener('blur', this.checkSelectionWrapper);
            }
            return this;
        },

        checkSelection: function () {
            var newSelection,
                selectionElement;

            if (this.keepToolbarAlive !== true && !this.options.disableToolbar) {
                newSelection = window.getSelection();
                if (newSelection.toString().trim() === '' ||
                    (this.options.allowMultiParagraphSelection === false && this.hasMultiParagraphs())) {
                    this.hideToolbarActions();
                } else {
                    selectionElement = this.getSelectionElement();
                    if (!selectionElement || selectionElement.getAttribute('data-disable-toolbar')) {
                        this.hideToolbarActions();
                    } else {
                        this.checkSelectionElement(newSelection, selectionElement);
                    }
                }
            }
            return this;
        },

        clickingIntoArchorForm: function (e) {
            var self = this;
            if (e.type && e.type.toLowerCase() === 'blur' && e.relatedTarget && e.relatedTarget === self.anchorInput) {
                return true;
            }
            return false;
        },

        hasMultiParagraphs: function () {
            var selectionHtml = getSelectionHtml().replace(/<[\S]+><\/[\S]+>/gim, ''),
                hasMultiParagraphs = selectionHtml.match(/<(p|h[0-6]|blockquote)>([\s\S]*?)<\/(p|h[0-6]|blockquote)>/g);

            return (hasMultiParagraphs ? hasMultiParagraphs.length : 0);
        },

        checkSelectionElement: function (newSelection, selectionElement) {
            var i;
            this.selection = newSelection;
            this.selectionRange = this.selection.getRangeAt(0);
            for (i = 0; i < this.elements.length; i += 1) {
                if (this.elements[i] === selectionElement) {
                    this.setToolbarButtonStates()
                        .setToolbarPosition()
                        .showToolbarActions();
                    return;
                }
            }
            this.hideToolbarActions();
        },

        getSelectionElement: function () {
            var selection = window.getSelection(),
                range = selection.getRangeAt(0),
                current = range.commonAncestorContainer,
                parent = current.parentNode,
                result,
                getMediumElement = function (e) {
                    var localParent = e;
                    try {
                        while (!localParent.getAttribute('data-medium-element')) {
                            localParent = localParent.parentNode;
                        }
                    } catch (errb) {
                        return false;
                    }
                    return localParent;
                };
            // First try on current node
            try {
                if (current.getAttribute('data-medium-element')) {
                    result = current;
                } else {
                    result = getMediumElement(parent);
                }
                // If not search in the parent nodes.
            } catch (err) {
                result = getMediumElement(parent);
            }
            return result;
        },

        setToolbarPosition: function () {
            var buttonHeight = 50,
                selection = window.getSelection(),
                range = selection.getRangeAt(0),
                boundary = range.getBoundingClientRect(),
                defaultLeft = (this.options.diffLeft) - (this.toolbar.offsetWidth / 2),
                middleBoundary = (boundary.left + boundary.right) / 2,
                halfOffsetWidth = this.toolbar.offsetWidth / 2;
            if (boundary.top < buttonHeight) {
                this.toolbar.classList.add('medium-toolbar-arrow-over');
                this.toolbar.classList.remove('medium-toolbar-arrow-under');
                this.toolbar.style.top = buttonHeight + boundary.bottom - this.options.diffTop + window.pageYOffset - this.toolbar.offsetHeight + 'px';
            } else {
                this.toolbar.classList.add('medium-toolbar-arrow-under');
                this.toolbar.classList.remove('medium-toolbar-arrow-over');
                this.toolbar.style.top = boundary.top + this.options.diffTop + window.pageYOffset - this.toolbar.offsetHeight + 'px';
            }
            if (middleBoundary < halfOffsetWidth) {
                this.toolbar.style.left = defaultLeft + halfOffsetWidth + 'px';
            } else if ((window.innerWidth - middleBoundary) < halfOffsetWidth) {
                this.toolbar.style.left = window.innerWidth + defaultLeft - halfOffsetWidth + 'px';
            } else {
                this.toolbar.style.left = defaultLeft + middleBoundary + 'px';
            }

            this.hideAnchorPreview();

            return this;
        },

        setToolbarButtonStates: function () {
            var buttons = this.toolbarActions.querySelectorAll('button'),
                i;
            for (i = 0; i < buttons.length; i += 1) {
                buttons[i].classList.remove('medium-editor-button-active');
            }
            this.checkActiveButtons();
            return this;
        },

        checkActiveButtons: function () {
            var parentNode = this.selection.anchorNode;
            if (!parentNode.tagName) {
                parentNode = this.selection.anchorNode.parentNode;
            }
            while (parentNode.tagName !== undefined && this.parentElements.indexOf(parentNode.tagName.toLowerCase) === -1) {
                this.activateButton(parentNode.tagName.toLowerCase());
                parentNode = parentNode.parentNode;
            }
        },

        activateButton: function (tag) {
            var el = this.toolbar.querySelector('[data-element="' + tag + '"]');
            if (el !== null && el.className.indexOf('medium-editor-button-active') === -1) {
                el.className += ' medium-editor-button-active';
            }
        },

        bindButtons: function () {
            var buttons = this.toolbar.querySelectorAll('button'),
                i,
                self = this,
                triggerAction = function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    if (self.selection === undefined) {
                        self.checkSelection();
                    }
                    if (this.className.indexOf('medium-editor-button-active') > -1) {
                        this.classList.remove('medium-editor-button-active');
                    } else {
                        this.className += ' medium-editor-button-active';
                    }
                    self.execAction(this.getAttribute('data-action'), e);
                };
            for (i = 0; i < buttons.length; i += 1) {
                buttons[i].addEventListener('click', triggerAction);
            }
            this.setFirstAndLastItems(buttons);
            return this;
        },

        setFirstAndLastItems: function (buttons) {
            buttons[0].className += ' medium-editor-button-first';
            buttons[buttons.length - 1].className += ' medium-editor-button-last';
            return this;
        },

        execAction: function (action, e) {
            if (action.indexOf('append-') > -1) {
                this.execFormatBlock(action.replace('append-', ''));
                this.setToolbarPosition();
                this.setToolbarButtonStates();
            } else if (action === 'anchor') {
                this.triggerAnchorAction(e);
            } else if (action === 'image') {
                document.execCommand('insertImage', false, window.getSelection());
            } else {
                document.execCommand(action, false, null);
                this.setToolbarPosition();
            }
        },

        triggerAnchorAction: function () {
            if (this.selection.anchorNode.parentNode.tagName.toLowerCase() === 'a') {
                document.execCommand('unlink', false, null);
            } else {
                if (this.anchorForm.style.display === 'block') {
                    this.showToolbarActions();
                } else {
                    this.showAnchorForm();
                }
            }
            return this;
        },

        execFormatBlock: function (el) {
            var selectionData = this.getSelectionData(this.selection.anchorNode);
            // FF handles blockquote differently on formatBlock
            // allowing nesting, we need to use outdent
            // https://developer.mozilla.org/en-US/docs/Rich-Text_Editing_in_Mozilla
            if (el === 'blockquote' && selectionData.el &&
                selectionData.el.parentNode.tagName.toLowerCase() === 'blockquote') {
                return document.execCommand('outdent', false, null);
            }
            if (selectionData.tagName === el) {
                el = 'p';
            }
            // When IE we need to add <> to heading elements and
            //  blockquote needs to be called as indent
            // http://stackoverflow.com/questions/10741831/execcommand-formatblock-headings-in-ie
            // http://stackoverflow.com/questions/1816223/rich-text-editor-with-blockquote-function/1821777#1821777
            if (this.isIE) {
                if (el === 'blockquote') {
                    return document.execCommand('indent', false, el);
                }
                el = '<' + el + '>';
            }
            return document.execCommand('formatBlock', false, el);
        },

        getSelectionData: function (el) {
            var tagName;

            if (el && el.tagName) {
                tagName = el.tagName.toLowerCase();
            }

            while (el && this.parentElements.indexOf(tagName) === -1) {
                el = el.parentNode;
                if (el && el.tagName) {
                    tagName = el.tagName.toLowerCase();
                }
            }

            return {
                el: el,
                tagName: tagName
            };
        },

        getFirstChild: function (el) {
            var firstChild = el.firstChild;
            while (firstChild !== null && firstChild.nodeType !== 1) {
                firstChild = firstChild.nextSibling;
            }
            return firstChild;
        },

        hideToolbarActions: function () {
            this.keepToolbarAlive = false;
            this.toolbar.classList.remove('medium-editor-toolbar-active');
        },

        showToolbarActions: function () {
            var self = this,
                timer;
            this.anchorForm.style.display = 'none';
            this.toolbarActions.style.display = 'block';
            this.keepToolbarAlive = false;
            clearTimeout(timer);
            timer = setTimeout(function () {
                if (!self.toolbar.classList.contains('medium-editor-toolbar-active')) {
                    self.toolbar.classList.add('medium-editor-toolbar-active');
                }
            }, 100);
        },

        showAnchorForm: function (link_value) {
            this.toolbarActions.style.display = 'none';
            this.savedSelection = saveSelection();
            this.anchorForm.style.display = 'block';
            this.keepToolbarAlive = true;
            this.anchorInput.focus();
            this.anchorInput.value = link_value || '';
        },

        bindAnchorForm: function () {
            var linkCancel = this.anchorForm.querySelector('a'),
                self = this;
            this.anchorForm.addEventListener('click', function (e) {
                e.stopPropagation();
            });
            this.anchorInput.addEventListener('keyup', function (e) {
                if (e.keyCode === 13) {
                    e.preventDefault();
                    self.createLink(this);
                }
            });
            this.anchorInput.addEventListener('click', function (e) {
                // make sure not to hide form when cliking into the input
                e.stopPropagation();
                self.keepToolbarAlive = true;
            });
            this.anchorInput.addEventListener('blur', function () {
                self.keepToolbarAlive = false;
                self.checkSelection();
            });
            linkCancel.addEventListener('click', function (e) {
                e.preventDefault();
                self.showToolbarActions();
                restoreSelection(self.savedSelection);
            });
            return this;
        },


        hideAnchorPreview: function () {
            this.anchorPreview.classList.remove('medium-editor-anchor-preview-active');
        },

        // TODO: break method
        showAnchorPreview: function (anchor_el) {
            if (this.anchorPreview.classList.contains('medium-editor-anchor-preview-active')) {
                return true;
            }

            var self = this,
                buttonHeight = 40,
                boundary = anchor_el.getBoundingClientRect(),
                middleBoundary = (boundary.left + boundary.right) / 2,
                halfOffsetWidth,
                defaultLeft,
                timer;

            self.anchorPreview.querySelector('i').innerHTML = anchor_el.href;
            halfOffsetWidth = self.anchorPreview.offsetWidth / 2;
            defaultLeft = self.options.diffLeft - halfOffsetWidth;

            clearTimeout(timer);
            timer = setTimeout(function () {
                if (!self.anchorPreview.classList.contains('medium-editor-anchor-preview-active')) {
                    self.anchorPreview.classList.add('medium-editor-anchor-preview-active');
                }
            }, 100);

            self.observeAnchorPreview(anchor_el);

            self.anchorPreview.classList.add('medium-toolbar-arrow-over');
            self.anchorPreview.classList.remove('medium-toolbar-arrow-under');
            self.anchorPreview.style.top = Math.round(buttonHeight + boundary.bottom - self.options.diffTop + window.pageYOffset - self.anchorPreview.offsetHeight) + 'px';
            if (middleBoundary < halfOffsetWidth) {
                self.anchorPreview.style.left = defaultLeft + halfOffsetWidth + 'px';
            } else if ((window.innerWidth - middleBoundary) < halfOffsetWidth) {
                self.anchorPreview.style.left = window.innerWidth + defaultLeft - halfOffsetWidth + 'px';
            } else {
                self.anchorPreview.style.left = defaultLeft + middleBoundary + 'px';
            }

            return this;
        },

        // TODO: break method
        observeAnchorPreview: function (anchorEl) {
            var self = this,
                lastOver = (new Date()).getTime(),
                over = true,
                stamp = function () {
                    lastOver = (new Date()).getTime();
                    over = true;
                },
                unstamp = function (e) {
                    if (!e.relatedTarget || !/anchor-preview/.test(e.relatedTarget.className)) {
                        over = false;
                    }
                },
                interval_timer = setInterval(function () {
                    if (over) {
                        return true;
                    }
                    var durr = (new Date()).getTime() - lastOver;
                    if (durr > self.options.anchorPreviewHideDelay) {
                        // hide the preview 1/2 second after mouse leaves the link
                        self.hideAnchorPreview();

                        // cleanup
                        clearInterval(interval_timer);
                        self.anchorPreview.removeEventListener('mouseover', stamp);
                        self.anchorPreview.removeEventListener('mouseout', unstamp);
                        anchorEl.removeEventListener('mouseover', stamp);
                        anchorEl.removeEventListener('mouseout', unstamp);

                    }
                }, 200);

            self.anchorPreview.addEventListener('mouseover', stamp);
            self.anchorPreview.addEventListener('mouseout', unstamp);
            anchorEl.addEventListener('mouseover', stamp);
            anchorEl.addEventListener('mouseout', unstamp);
        },

        createAnchorPreview: function () {
            var self = this,
                anchorPreview = document.createElement('div');

            anchorPreview.id = 'medium-editor-anchor-preview-' + this.id;
            anchorPreview.className = 'medium-editor-anchor-preview';
            anchorPreview.innerHTML = this.anchorPreviewTemplate();
            document.body.appendChild(anchorPreview);

            anchorPreview.addEventListener('click', function () {
                self.anchorPreviewClickHandler();
            });

            return anchorPreview;
        },

        anchorPreviewTemplate: function () {
            return '<div class="medium-editor-toolbar-anchor-preview" id="medium-editor-toolbar-anchor-preview">' +
                '    <i class="medium-editor-toolbar-anchor-preview-inner"></i>' +
                '</div>';
        },

        anchorPreviewClickHandler: function (e) {
            if (this.activeAnchor) {

                var self = this,
                    range = document.createRange(),
                    sel = window.getSelection();

                range.selectNodeContents(self.activeAnchor);
                sel.removeAllRanges();
                sel.addRange(range);
                setTimeout(function () {
                    self.showAnchorForm(self.activeAnchor.href);
                    self.keepToolbarAlive = false;
                }, 100 + self.options.delay);

            }

            this.hideAnchorPreview();
        },

        editorAnchorObserver: function (e) {
            var self = this,
                overAnchor = true,
                leaveAnchor = function () {
                    // mark the anchor as no longer hovered, and stop listening
                    overAnchor = false;
                    self.activeAnchor.removeEventListener('mouseout', leaveAnchor);
                };

            if (e.target && e.target.tagName.toLowerCase() === 'a') {

                // Detect empty href attributes
                // The browser will make href="" or href="#top" 
                // into absolute urls when accessed as e.targed.href, so check the html
                if (!/href=["']\S+["']/.test(e.target.outerHTML) || /href=["']#\S+["']/.test(e.target.outerHTML)) {
                    return true;
                }

                // only show when hovering on anchors
                if (this.toolbar.classList.contains('medium-editor-toolbar-active')) {
                    // only show when toolbar is not present
                    return true;
                }
                this.activeAnchor = e.target;
                this.activeAnchor.addEventListener('mouseout', leaveAnchor);
                // show the anchor preview according to the configured delay
                // if the mouse has not left the anchor tag in that time
                setTimeout(function () {
                    if (overAnchor) {
                        self.showAnchorPreview(e.target);
                    }
                }, self.options.delay);


            }
        },

        bindAnchorPreview: function (index) {
            var self = this;
            this.elements[index].addEventListener('mouseover', function (e) {
                self.editorAnchorObserver(e);
            });
            return this;
        },

        setTargetBlank: function () {
            var el = getSelectionStart(),
                i;
            if (el.tagName.toLowerCase() === 'a') {
                el.target = '_blank';
            } else {
                el = el.getElementsByTagName('a');
                for (i = 0; i < el.length; i += 1) {
                    el[i].target = '_blank';
                }
            }
        },

        createLink: function (input) {
            restoreSelection(this.savedSelection);
            document.execCommand('createLink', false, input.value);
            if (this.options.targetBlank) {
                this.setTargetBlank();
            }
            this.showToolbarActions();
            input.value = '';
        },

        bindWindowActions: function () {
            var timerResize,
                self = this;
            this.windowResizeHandler = function () {
                clearTimeout(timerResize);
                timerResize = setTimeout(function () {
                    if (self.toolbar && self.toolbar.classList.contains('medium-editor-toolbar-active')) {
                        self.setToolbarPosition();
                    }
                }, 100);
            };
            window.addEventListener('resize', this.windowResizeHandler);
            return this;
        },

        activate: function () {
            if (this.isActive) {
                return;
            }

            this.setup();
        },

        // TODO: break method
        deactivate: function () {
            var i;
            if (!this.isActive) {
                return;
            }
            this.isActive = false;

            if (this.toolbar !== undefined) {
                document.body.removeChild(this.anchorPreview);
                document.body.removeChild(this.toolbar);
                delete this.toolbar;
                delete this.anchorPreview;
            }

            document.documentElement.removeEventListener('mouseup', this.checkSelectionWrapper);
            window.removeEventListener('resize', this.windowResizeHandler);

            for (i = 0; i < this.elements.length; i += 1) {
                this.elements[i].removeEventListener('keyup', this.checkSelectionWrapper);
                this.elements[i].removeEventListener('blur', this.checkSelectionWrapper);
                this.elements[i].removeEventListener('paste', this.pasteWrapper);
                this.elements[i].removeAttribute('contentEditable');
                this.elements[i].removeAttribute('data-medium-element');
            }

        },

        bindPaste: function () {
            var i, self = this;
            this.pasteWrapper = function (e) {
                var paragraphs,
                    html = '',
                    p;

                this.classList.remove('medium-editor-placeholder');
                if (!self.options.forcePlainText) {
                    return this;
                }

                if (e.clipboardData && e.clipboardData.getData && !e.defaultPrevented) {
                    e.preventDefault();
                    if (!self.options.disableReturn) {
                        paragraphs = e.clipboardData.getData('text/plain').split(/[\r\n]/g);
                        for (p = 0; p < paragraphs.length; p += 1) {
                            if (paragraphs[p] !== '') {
                                html += '<p>' + paragraphs[p] + '</p>';
                            }
                        }
                        document.execCommand('insertHTML', false, html);
                    } else {
                        document.execCommand('insertHTML', false, e.clipboardData.getData('text/plain'));
                    }
                }
            };
            for (i = 0; i < this.elements.length; i += 1) {
                this.elements[i].addEventListener('paste', this.pasteWrapper);
            }
            return this;
        },

        setPlaceholders: function () {
            var i,
                activatePlaceholder = function (el) {
                    if (el.textContent.replace(/^\s+|\s+$/g, '') === '') {
                        el.classList.add('medium-editor-placeholder');
                    }
                },
                placeholderWrapper = function (e) {
                    this.classList.remove('medium-editor-placeholder');
                    if (e.type !== 'keypress') {
                        activatePlaceholder(this);
                    }
                };
            for (i = 0; i < this.elements.length; i += 1) {
                activatePlaceholder(this.elements[i]);
                this.elements[i].addEventListener('blur', placeholderWrapper);
                this.elements[i].addEventListener('keypress', placeholderWrapper);
            }
            return this;
        }

    };

}(window, document));

var OrderedListComponent;

OrderedListComponent = (function() {
  function OrderedListComponent() {}

  OrderedListComponent.prototype.name = 'Ordered List';

  OrderedListComponent.prototype.id = 'ordered-list';

  OrderedListComponent.prototype.type = 'group';

  OrderedListComponent.prototype.template = '<ol class="ordered-list"> <li ng-repeat="b in block.blocks"> <faber-render data-faber-render-block="b"/> </li> </ol>';

  OrderedListComponent.prototype.init = function($scope, $element, content) {};

  return OrderedListComponent;

})();


/*! @source http://purl.eligrey.com/github/classList.js/blob/master/classList.js*/
;if("document" in self&&!("classList" in document.createElement("_"))){(function(j){"use strict";if(!("Element" in j)){return}var a="classList",f="prototype",m=j.Element[f],b=Object,k=String[f].trim||function(){return this.replace(/^\s+|\s+$/g,"")},c=Array[f].indexOf||function(q){var p=0,o=this.length;for(;p<o;p++){if(p in this&&this[p]===q){return p}}return -1},n=function(o,p){this.name=o;this.code=DOMException[o];this.message=p},g=function(p,o){if(o===""){throw new n("SYNTAX_ERR","An invalid or illegal string was specified")}if(/\s/.test(o)){throw new n("INVALID_CHARACTER_ERR","String contains an invalid character")}return c.call(p,o)},d=function(s){var r=k.call(s.getAttribute("class")||""),q=r?r.split(/\s+/):[],p=0,o=q.length;for(;p<o;p++){this.push(q[p])}this._updateClassName=function(){s.setAttribute("class",this.toString())}},e=d[f]=[],i=function(){return new d(this)};n[f]=Error[f];e.item=function(o){return this[o]||null};e.contains=function(o){o+="";return g(this,o)!==-1};e.add=function(){var s=arguments,r=0,p=s.length,q,o=false;do{q=s[r]+"";if(g(this,q)===-1){this.push(q);o=true}}while(++r<p);if(o){this._updateClassName()}};e.remove=function(){var t=arguments,s=0,p=t.length,r,o=false;do{r=t[s]+"";var q=g(this,r);if(q!==-1){this.splice(q,1);o=true}}while(++s<p);if(o){this._updateClassName()}};e.toggle=function(p,q){p+="";var o=this.contains(p),r=o?q!==true&&"remove":q!==false&&"add";if(r){this[r](p)}return !o};e.toString=function(){return this.join(" ")};if(b.defineProperty){var l={get:i,enumerable:true,configurable:true};try{b.defineProperty(m,a,l)}catch(h){if(h.number===-2146823252){l.enumerable=false;b.defineProperty(m,a,l)}}}else{if(b[f].__defineGetter__){m.__defineGetter__(a,i)}}}(self))};
;
var MediumEditorExtended, RichTextComponent,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MediumEditorExtended = (function(_super) {
  __extends(MediumEditorExtended, _super);

  function MediumEditorExtended(elements, options) {
    this.defaults.firstHeader = 'h1';
    this.defaults.secondHeader = 'h2';
    this.init(elements, options);
  }

  MediumEditorExtended.prototype.init = function(elements, options) {
    return MediumEditorExtended.__super__.init.call(this, elements, options);
  };

  MediumEditorExtended.prototype.buttonTemplate = function(btnType) {
    var buttonTemplates;
    buttonTemplates = {
      'header3': '<li><button class="medium-editor-action medium-editor-action-header3" data-action="append-h3" data-element="h3">H3</button></li>'
    };
    return MediumEditorExtended.__super__.buttonTemplate.call(this, btnType) || buttonTemplates[btnType];
  };

  return MediumEditorExtended;

})(MediumEditor);

RichTextComponent = (function() {
  function RichTextComponent() {}

  RichTextComponent.prototype.name = 'Rich Text';

  RichTextComponent.prototype.id = 'rich-text';

  RichTextComponent.prototype.type = 'element';

  RichTextComponent.prototype.template = '<div class="rich-text-editor" data-tust-html><br/></div>';

  RichTextComponent.prototype.editor = null;

  RichTextComponent.prototype.editorInstance = null;

  RichTextComponent.prototype.init = function($scope, $element, initialContent, update) {
    var opts;
    opts = {
      buttons: ['bold', 'italic', 'underline', 'anchor', 'unorderedlist', 'orderedlist', 'header1', 'header2', 'header3', 'quote'],
      placeholder: 'Type your text'
    };
    this.editor = $element[0].getElementsByClassName('rich-text-editor')[0];
    this.editor.innerHTML = initialContent || '';
    this.editorInstance = new MediumEditorExtended(this.editor, opts);
    return this.editor.addEventListener('input', (function(_this) {
      return function() {
        return update(_this.editor.innerHTML);
      };
    })(this));
  };

  RichTextComponent.prototype.selected = function($scope, $element, update) {
    return $element[0].getElementsByClassName('rich-text-editor')[0].focus();
  };

  RichTextComponent.prototype.unselected = function($scope, $element, update) {
    return update(this.editor.innerHTML);
  };

  return RichTextComponent;

})();

var FaberComponent;

FaberComponent = (function() {
  FaberComponent.prototype.id = '';

  FaberComponent.prototype.name = '';

  FaberComponent.prototype.type = 'group';

  FaberComponent.prototype.template = '';

  FaberComponent.prototype.topLevelOnly = false;

  function FaberComponent(opts) {
    if (opts == null) {
      opts = [];
    }
    this.id = opts.id || '';
    this.name = opts.name || '';
    this.type = opts.type || 'group';
    this.template = opts.template || '';
    this.topLevelOnly = opts.type === 'group' && (opts.topLevelOnly === true || opts.topLevelOnly === void 0);
  }

  FaberComponent.prototype.init = function($element, update) {};

  FaberComponent.prototype.selected = function($element) {};

  FaberComponent.prototype.unselected = function($element) {};

  return FaberComponent;

})();

window.faber = angular.extend(angular.module('faber', ['ngAnimate']).value('faberConfig', {}).run(function(configService, contentService) {
  faber["import"] = contentService["import"];
  faber["export"] = contentService["export"];
  faber.init = configService.init;
  return faber.init(faber.initialConfig);
}), {
  init: function(config) {
    return this.initialConfig = config;
  }
});

angular.module('faber').animation('.faber-block-repeat', function($window, $document, $rootElement, $interval) {
  var getEnd;
  getEnd = function(el) {
    var pos;
    pos = 0;
    if (el.offsetParent) {
      while (true) {
        pos += el.offsetTop;
        el = el.offsetParent;
        if (!el) {
          break;
        }
      }
    }
    return Math.max(pos, 0);
  };
  return {
    move: function($element, done) {
      var distance, end, start;
      start = $window.pageYOffset;
      end = getEnd($element[0]) - 40;
      distance = end - start;
      $interval.cancel($window.faberBlockRepeatAnimationWatch);
      $window.faberBlockRepeatAnimationWatch = $interval(function() {
        distance /= 2;
        $window.scrollBy(0, distance);
        if (Math.abs(distance) <= 1) {
          return $interval.cancel($window.faberBlockRepeatAnimationWatch);
        }
      }, 50);
      return null;
    }
  };
});

angular.module('faber').controller('BlockController', function($rootScope, $scope, $log, componentsService, contentService) {
  $scope.block || ($scope.block = {});
  $scope.components = componentsService.getAll();
  $scope.component = null;
  $scope.validateBlock = function(block) {
    var component, isTopLevelScope, result;
    result = true;
    if (angular.isString(block.component)) {
      component = componentsService.findById(block.component);
    } else if (angular.isObject(block.component) && angular.isString(block.component.id)) {
      component = componentsService.findById(block.component.id);
    }
    if (component) {
      isTopLevelScope = $scope.isTopLevel;
      result &= !component.topLevelOnly || (component.topLevelOnly && isTopLevelScope);
    } else {
      return false;
    }
    return result &= !block.inputs || angular.isObject(block.inputs);
  };
  $scope.add = function(block) {
    var _base;
    if ($scope.validateBlock(block)) {
      (_base = $scope.block).blocks || (_base.blocks = []);
      $scope.block.blocks.push(block);
      return true;
    } else {
      $log.warn({
        'cannot find a component of the given name': block.component
      });
      return false;
    }
  };
  $scope.remove = function(block) {
    if (confirm('Are you sure you want to permanently remove this block?\n\nYou can\'t undo this action.')) {
      $scope.block.blocks.splice($scope.block.blocks.indexOf(block), 1);
      return contentService.save();
    }
  };
  $scope.insert = function(index, block) {
    if ($scope.validateBlock(block)) {
      return $scope.block.blocks.splice(index, 0, block);
    }
  };
  $scope.insertGroup = function(index) {
    return $scope.block.blocks.splice(index, 0, {
      component: componentsService.findByType('group')[0].id
    });
  };
  $scope.move = function(from, to) {
    var max;
    max = $scope.block.blocks.length;
    if (from >= 0 && from < max && to >= 0 && to < max) {
      $scope.block.blocks.splice(to, 0, $scope.block.blocks.splice(from, 1)[0]);
      $scope.$broadcast('BlockMoved');
      return contentService.save();
    }
  };
  $scope.$watch('block.component', function(val) {
    var component;
    if (val) {
      component = componentsService.findById(val);
      if (!component && componentsService.getAll().length > 0) {
        return $log.warn({
          'cannot find a component of the given name': val
        });
      } else {
        $scope.component = component || new FaberComponent();
        return contentService.save();
      }
    }
  });
  $scope.$watch('block.content', function() {
    return contentService.save();
  });
  return $scope.$watch('block.blocks', function() {
    return contentService.save();
  });
});

angular.module('faber').controller('EditorController', function($rootScope, $scope, $controller, $log, configService, contentService, componentsService) {
  var configEditor, validateElementBlock, validateGroupBlock, validateImported;
  configEditor = function(config) {
    $rootScope.isExpanded = angular.isDefined(config.expanded) ? config.expanded : true;
    componentsService.init(config.components || []);
    return $scope.components = componentsService.getAll();
  };
  $controller('BlockController', {
    $scope: $scope
  });
  $scope.isTopLevel = true;
  $scope.block.blocks = [];
  contentService.init($scope.block);
  configEditor(configService.get());
  validateElementBlock = function(block) {
    var _ref;
    if ($scope.validateBlock(block && ((_ref = block.blocks) != null ? _ref.length : void 0) > 0)) {
      block.blocks = validateImported(block.blocks);
    }
    return block;
  };
  validateGroupBlock = function(block) {
    var groupItem, _i, _len, _ref, _ref1, _ref2;
    if (((_ref = block.blocks) != null ? _ref.length : void 0) > 0) {
      _ref1 = block.blocks;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        groupItem = _ref1[_i];
        if (((_ref2 = groupItem.blocks) != null ? _ref2.length : void 0) > 0) {
          groupItem.blocks = validateImported(groupItem.blocks);
        }
      }
    }
    return block;
  };
  validateImported = function(blocks) {
    var block, component, validated, _i, _len;
    validated = [];
    for (_i = 0, _len = blocks.length; _i < _len; _i++) {
      block = blocks[_i];
      component = componentsService.findById(block.component);
      if (component) {
        if (component.type === 'element') {
          validated.push(validateElementBlock(block));
        }
        if (component.type === 'group') {
          validated.push(validateGroupBlock(block));
        }
      } else {
        $log.warn({
          'cannot find a component with the given id': block.component
        });
      }
    }
    return validated;
  };
  $scope.$on('imported', function(evt, blocks) {
    return $scope.$apply(function() {
      return $scope.block.blocks = validateImported(blocks);
    });
  });
  return $scope.$on('ConfigUpdated', function(evt, config) {
    return configEditor(config);
  });
});

angular.module('faber').controller('ElementBlockController', function() {
  return $controller('BlockController', {
    $scope: $scope
  });
});

angular.module('faber').controller('GroupBlockController', function($rootScope, $controller, $scope, componentsService) {
  var _base;
  $controller('BlockController', {
    $scope: $scope
  });
  (_base = $scope.block).blocks || (_base.blocks = []);
  $scope.components = [
    {
      name: 'Item',
      id: 'group-item',
      template: ''
    }
  ];
  $scope.groupComponents = componentsService.findByType('group');
  return $scope.insertGroupItem = function(index) {
    var groupItem;
    groupItem = {
      blocks: []
    };
    return $scope.block.blocks.splice(index, 0, groupItem);
  };
});

angular.module('faber').controller('GroupItemBlockController', function($rootScope, $controller, $scope, componentsService) {
  var _base;
  $controller('BlockController', {
    $scope: $scope
  });
  (_base = $scope.block).blocks || (_base.blocks = []);
  return $scope.components = componentsService.findByType('element');
});

angular.module('faber').directive('faberBlock', function($rootScope, $compile, $timeout) {
  var isEventTargetSelect;
  isEventTargetSelect = function(evt) {
    return evt && evt.target && evt.target.tagName.toLowerCase() === 'select';
  };
  return {
    scope: {
      'block': '=faberBlockContent'
    },
    restrict: 'E',
    templateUrl: 'faber-block.html',
    controller: 'BlockController',
    compile: function($element, $attrs, transclude) {
      var compiledContents, contents;
      contents = $element.contents().remove();
      compiledContents = null;
      return {
        pre: function($scope, $element, $attrs) {
          if (!compiledContents) {
            compiledContents = $compile(contents, transclude);
          }
          return compiledContents($scope, function(clone, $scope) {
            return $element.append(clone);
          });
        },
        post: function($scope, $element, $attrs) {
          $scope.currentIndex = $scope.$parent.$index;
          $scope.isExpanded = !!$rootScope.isExpanded;
          $scope.isSelected = false;
          $scope.isMoving = false;
          $scope.isPreview = false;
          $scope.isGroupBlock = false;
          $scope.isGroupItemBlock = false;
          $scope.isElementBlock = false;
          $scope.isMouseHover = false;
          $scope.mouseOver = function(evt) {
            return $scope.isMouseHover = true;
          };
          $scope.mouseOut = function(evt) {
            if (!isEventTargetSelect(evt)) {
              return $scope.isMouseHover = false;
            }
          };
          $scope.indexRange = function() {
            var i, max, min, res, _i;
            res = [];
            min = 0;
            max = $scope.$parent && $scope.$parent.block && $scope.$parent.block.blocks ? Math.max($scope.$parent.block.blocks.length - 1, min) : min;
            for (i = _i = min; min <= max ? _i <= max : _i >= max; i = min <= max ? ++_i : --_i) {
              res.push(i);
            }
            return res;
          };
          $scope.onSelectChange = function() {
            var to;
            to = $element.find('select').val();
            if (to >= 0) {
              $scope.moveSelf(to);
              $rootScope.$broadcast('ResetIsMoving');
              return $timeout(function() {
                return $scope.isMoving = true;
              });
            }
          };
          $scope.onBlockClick = function(evt) {
            if (evt) {
              evt.stopPropagation();
            }
            if (!isEventTargetSelect(evt)) {
              $rootScope.$broadcast('ShowComponents', null);
              return $rootScope.$broadcast('SelectBlockOfIndex', $scope.$parent, $scope.$parent.block.blocks.indexOf($scope.block));
            }
          };
          $scope.select = function(evt) {
            return $scope.isSelected = true;
          };
          $scope.unselect = function(evt) {
            return $scope.isSelected = false;
          };
          $scope.removeSelf = function() {
            return $scope.$parent.remove($scope.block);
          };
          $scope.moveSelf = function(to) {
            return $scope.$parent.move($scope.$parent.block.blocks.indexOf($scope.block), to);
          };
          $scope.edit = function(evt) {
            if (evt) {
              evt.stopPropagation();
            }
            $scope.isPreview = false;
            $rootScope.$broadcast('ResetIsMoving');
            return $scope.$broadcast('BlockModeChanged', $scope.isPreview);
          };
          $scope.preview = function(evt) {
            if (evt) {
              evt.stopPropagation();
            }
            $scope.isPreview = true;
            return $scope.$broadcast('BlockModeChanged', $scope.isPreview);
          };
          $scope.expand = function(evt) {
            if (evt) {
              evt.stopPropagation();
            }
            return $scope.isExpanded = true;
          };
          $scope.collapse = function(evt) {
            if (evt) {
              evt.stopPropagation();
            }
            return $scope.isExpanded = false;
          };
          $scope.$on('ResetIsMoving', function(evt) {
            return $scope.isMoving = false;
          });
          $scope.$on('SelectBlockOfIndex', function(evt, scope, index) {
            if (!scope) {
              $scope.unselect();
              return;
            }
            if (scope.block.blocks[index] === $scope.block) {
              return $scope.select();
            } else {
              return $scope.unselect();
            }
          });
          $scope.$on('CollapseAll', function(evt) {
            return $scope.isExpanded = false;
          });
          $scope.$on('ExpandAll', function(evt) {
            return $scope.isExpanded = true;
          });
          return $scope.$watchCollection('[$parent.component, component]', function() {
            $scope.isElementBlock = $scope.isGroupBlock = $scope.isGroupItemBlock = false;
            if ($scope.$parent.component && $scope.$parent.component.type === 'group') {
              return $scope.isGroupItemBlock = true;
            } else if ($scope.component) {
              if ($scope.component.type === 'element') {
                $scope.isElementBlock = true;
              }
              if ($scope.component.type === 'group') {
                return $scope.isGroupBlock = true;
              }
            }
          });
        }
      };
    }
  };
});

angular.module('faber').directive('faberComponentRenderer', function($compile, componentsService) {
  return {
    restrict: 'AE',
    template: '<div ng-class="component.id"></div>',
    scope: {
      block: '=faberComponentRendererBlock',
      checkGroupPreview: '&faberGroupPreview'
    },
    link: function($scope, $element, $attrs) {
      var setComponent;
      $scope.isGroupPreview = $scope.checkGroupPreview() || false;
      setComponent = function(content) {
        var $component, template, wrapper;
        template = $scope.component.template;
        $component = $compile(template)($scope);
        wrapper = $element.find('div');
        wrapper.empty();
        $element.find('div').append($component);
        if ($scope.component.init) {
          if ($scope.component.type === 'element') {
            $scope.component.init($scope, $element, content, $scope.updateRendered);
          }
          if ($scope.component.type === 'group') {
            return $scope.component.init($scope, $element, content);
          }
        }
      };
      $scope.component = null;
      $scope.selectRendered = function() {
        if ($scope.component.selected) {
          return $scope.component.selected($scope, $element, $scope.updateRendered);
        }
      };
      $scope.unselectRendered = function() {
        if ($scope.component.unselected) {
          return $scope.component.unselected($scope, $element, $scope.updateRendered);
        }
      };
      $scope.updateRendered = function(content) {
        if (content) {
          return $scope.block.content = content;
        }
      };
      $scope.$watch('block.component', function(val) {
        var initialContent;
        if (!$scope.block) {
          return;
        }
        $scope.component = componentsService.findById($scope.block.component);
        if ($scope.block.component && $scope.component) {
          initialContent = $scope.component.type === 'element' ? $scope.block.content : angular.copy($scope.block.blocks);
          return setComponent(initialContent);
        }
      });
      $scope.$on('BlockModeChanged', function(evt, val) {
        return setComponent($scope.block.content);
      });
      return $scope.$on('SelectBlockOfIndex', function(evt, scope, index) {
        if (!scope) {
          $scope.unselectRendered();
          return;
        }
        if (scope.block.blocks[index] === $scope.block) {
          return $scope.selectRendered();
        }
      });
    }
  };
});

angular.module('faber').directive('faberComponents', function($rootScope, $filter, $timeout) {
  var buttonClickWithIndexReturn;
  buttonClickWithIndexReturn = function(evt, $scope) {
    if (evt) {
      evt.stopPropagation();
    }
    $rootScope.$broadcast('SelectBlockOfIndex', null);
    $scope.showingComponents = false;
    return $scope.$index + 1 || 0;
  };
  return {
    restrict: 'AE',
    templateUrl: 'faber-components.html',
    link: function($scope, $element, attrs) {
      $scope.showingComponents = $scope.block.blocks.length === 0;
      $scope.hasGroupComponents = function() {
        var groupComponents;
        groupComponents = $filter('filter')($scope.components, {
          type: 'group'
        }, true);
        return groupComponents.length > 0;
      };
      $scope.$watch('showingComponents', function(newValue) {
        if (newValue) {
          return $rootScope.$broadcast('ShowComponents', $scope.$id);
        }
      });
      $scope.$watch('isExpanded', function(val) {
        if ($scope.isGroupItemBlock) {
          if (val) {
            if ($scope.block.blocks.length === 0) {
              return $scope.showingComponents = true;
            }
          } else {
            return $scope.showingComponents = false;
          }
        }
      });
      $scope.$on('ShowComponents', function(evt, id) {
        if (id !== $scope.$id) {
          return $scope.showingComponents = false;
        }
      });
      $scope.insertBlock = function(evt, comp) {
        var index;
        if (evt) {
          evt.stopPropagation();
        }
        $scope.showingComponents = false;
        index = $scope.isExpanded ? $scope.$index + 1 || 0 : $scope.block.blocks.length;
        if ($scope.isGroupItemBlock) {
          $scope.expand();
        }
        $scope.insert(index, comp);
        return $timeout(function() {
          return $rootScope.$broadcast('SelectBlockOfIndex', $scope, index);
        });
      };
      $scope.insertGroupBlock = function(evt) {
        return $scope.insertGroup(buttonClickWithIndexReturn(evt, $scope));
      };
      $scope.insertGroupItemBlock = function(evt) {
        return $scope.insertGroupItem(buttonClickWithIndexReturn(evt, $scope));
      };
      return $scope.toggleComponents = function(evt) {
        if (evt) {
          evt.stopPropagation();
        }
        return $scope.showingComponents = !$scope.showingComponents;
      };
    }
  };
});

angular.module('faber').directive('faberEditor', function($rootScope, $document, $timeout) {
  return {
    restrict: 'AE',
    templateUrl: 'faber-editor.html',
    controller: 'EditorController',
    link: function($scope, $element, attrs) {
      $document[0].addEventListener('click', function(evt) {
        var el, isInside;
        isInside = false;
        el = evt.target;
        while (el && el.tagName && (el.tagName.toLowerCase() !== 'body')) {
          if (el === $element[0]) {
            isInside = true;
            break;
          } else {
            el = el.parentNode;
          }
        }
        if (!isInside) {
          return $rootScope.$apply(function() {
            $rootScope.$broadcast('ShowComponents', null);
            return $rootScope.$broadcast('SelectBlockOfIndex', null);
          });
        }
      }, true);
      $scope.$on('imported', function(evt, blocks) {
        return $timeout(function() {
          return $rootScope.$broadcast('ShowComponents', null);
        });
      });
      return $rootScope.$watch('isExpanded', function() {
        return $rootScope.$broadcast($rootScope.isExpanded ? 'ExpandAll' : 'CollapseAll');
      });
    }
  };
});

angular.module('faber').directive('faberElementBlock', function($rootScope, $compile, $timeout) {
  return {
    restrict: 'E',
    templateUrl: 'faber-element-block.html',
    controller: 'BlockController'
  };
});

angular.module('faber').directive('faberGroupBlock', function() {
  return {
    restrict: 'E',
    templateUrl: 'faber-group-block.html',
    controller: 'GroupBlockController',
    link: function($scope, $element, attrs) {
      $scope.$watch('component', function(val) {
        if (val) {
          return $scope.currentComponent = val.id;
        }
      });
      return $scope.$watch('currentComponent', function(val) {
        var _ref;
        if (val !== ((_ref = $scope.component) != null ? _ref.id : void 0)) {
          $scope.block.component = val;
          return $scope.isSelected = true;
        }
      });
    }
  };
});

angular.module('faber').directive('faberGroupItemBlock', function() {
  return {
    restrict: 'E',
    templateUrl: 'faber-group-item-block.html',
    controller: 'GroupItemBlockController',
    link: function($scope, $element, attrs, blockController) {
      return $element[0].querySelector('.faber-group-item-title input').focus();
    }
  };
});

angular.module('faber').directive('faberRender', function($compile, componentsService) {
  return {
    restrict: 'AE',
    templateUrl: 'faber-render.html',
    scope: {
      data: '=faberRenderBlock'
    },
    link: function($scope, $element, $attrs) {
      return $scope.isGroupPreview = function() {
        return true;
      };
    }
  };
});

angular.module('faber').directive('trustHtml', function($sce) {
  return {
    replace: true,
    restrict: 'M',
    template: '<div ng-bind-html="trustedHtml"></div>',
    link: function($scope, $element, attrs) {
      return $scope.$watch(attrs.trustHtml, function(newValue, oldValue) {
        if ((newValue != null) !== oldValue) {
          return $scope.trustedHtml = $sce.trustAsHtml(newValue);
        }
      });
    }
  };
});

angular.module("faber").run(["$templateCache", function($templateCache) {$templateCache.put("faber-block.html","<div ng-class=\"{\'faber-element-block\': isElementBlock, \'faber-group-block\': isGroupBlock, \'faber-group-item-block\': isGroupItemBlock, \'faber-block-preview\': isPreview,\'faber-block-hover\': isMouseHover, \'faber-block-selected\': isSelected, \'faber-block-moving\': isMoving}\" ng-mouseover=\"mouseOver($event)\" ng-mouseout=\"mouseOut($event)\" ng-click=\"onBlockClick($event)\" class=\"faber-block-item\"><div class=\"faber-block-actions\"><div ng-if=\"isGroupBlock\" class=\"faber-group-block-actions\"><button title=\"Edit\" ng-if=\"isPreview\" ng-click=\"edit($event)\" class=\"faber-edit-group-button faber-icon-edit toggled-on\"></button><button title=\"Preview\" ng-if=\"!isPreview\" ng-click=\"preview($event)\" class=\"faber-preview-group-button faber-icon-edit\"></button></div><div ng-if=\"isGroupItemBlock\" class=\"faber-group-item-block-actions\"><button title=\"Expand\" ng-if=\"!isExpanded\" ng-click=\"expand($event)\" class=\"faber-icon-plus\"></button><button title=\"Collapse\" ng-if=\"isExpanded\" ng-click=\"collapse($event)\" class=\"faber-icon-minus\"></button></div><label class=\"faber-select faber-block-position\"><select ng-model=\"$parent.$index\" ng-options=\"i as (i == $parent.$index ? (i+1)+\' (current)\' : i+1) for i in indexRange()\" ng-change=\"onSelectChange()\"></select><button title=\"Change order\" class=\"faber-icon-sort\"></button></label><button title=\"Remove\" ng-click=\"removeSelf()\" class=\"faber-icon-remove\"></button></div><faber-group-item-block ng-if=\"isGroupItemBlock\"></faber-group-item-block><faber-element-block ng-if=\"isElementBlock\"></faber-element-block><faber-group-block ng-if=\"isGroupBlock\" ng-class=\"{\'faber-group-block-preview\': isPreview}\"></faber-group-block></div>");
$templateCache.put("faber-components.html","<div ng-click=\"toggleComponents($event)\"><div ng-if=\"!showingComponents\" class=\"faber-components-line\"></div><i ng-if=\"!showingComponents\" class=\"faber-icon-plus\"></i><ul ng-if=\"showingComponents\" class=\"faber-available-components\"><li ng-repeat=\"comp in components | filter : {type: \'element\'}\" class=\"faber-component\"><button ng-click=\"insertBlock($event, {component: comp.id })\">{{comp.name}}</button></li><li ng-if=\"hasGroupComponents()\" class=\"faber-component\"><button ng-click=\"insertGroupBlock($event)\" class=\"faber-group-button\"><span class=\"faber-icon-group\"></span>Group</button></li><li ng-if=\"component.type == \'group\'\" class=\"faber-component\"><button ng-click=\"insertGroupItemBlock($event)\" class=\"faber-group-button\">Item</button></li></ul></div>");
$templateCache.put("faber-editor.html","<faber-components></faber-components><div class=\"faber-blocks\"><div ng-repeat=\"data in block.blocks\" class=\"faber-block-repeat\"><faber-block data-faber-block-content=\"data\"></faber-block><faber-components></faber-components></div></div>");
$templateCache.put("faber-element-block.html","<faber-component-renderer data-faber-component-renderer-block=\"block\"></faber-component-renderer>");
$templateCache.put("faber-group-block.html","<label ng-hide=\"isPreview\" class=\"faber-select faber-group-component\"><span>{{component.name}}<select ng-model=\"currentComponent\" ng-options=\"c.id as c.name for c in groupComponents\"></select><i class=\"faber-icon-button faber-icon-arrow-down\"></i></span></label><faber-component-renderer data-faber-component-renderer-block=\"block\" ng-if=\"isPreview\"></faber-component-renderer><faber-components ng-if=\"!isPreview\"></faber-components><div ng-hide=\"isPreview\" class=\"faber-blocks\"><div ng-repeat=\"data in block.blocks\" class=\"faber-block-repeat\"><faber-block data-faber-block-content=\"data\"></faber-block><faber-components></faber-components></div></div>");
$templateCache.put("faber-group-item-block.html","<label class=\"faber-group-item-title\"><input type=\"text\" placeholder=\"Type the item\'s title\" ng-model=\"block.title\"/></label><faber-components ng-if=\"isExpanded\"></faber-components><div ng-if=\"isExpanded\" class=\"faber-blocks\"><div ng-repeat=\"data in block.blocks\" class=\"faber-block-repeat\"><faber-block data-faber-block-content=\"data\"></faber-block><faber-components></faber-components></div></div>");
$templateCache.put("faber-render.html","<div ng-repeat=\"block in data.blocks\" ng-if=\"data\"><faber-component-renderer data-faber-component-renderer-block=\"block\" data-faber-group-preview=\"isGroupPreview()\"></faber-component-renderer></div>");}]);
angular.module('faber').factory('componentsService', function($filter, $log) {
  var raws, validate;
  raws = [];
  validate = function(component) {
    var comp;
    comp = new component();
    return angular.isString(comp.id) && (comp.type === 'element' || comp.type === 'group');
  };
  return {
    init: function(list) {
      var comp, _i, _len, _results;
      raws = [];
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        comp = list[_i];
        if (validate(comp)) {
          _results.push(raws.push(comp));
        } else {
          _results.push($log.warn({
            'invalid': comp
          }));
        }
      }
      return _results;
    },
    getAll: function() {
      var comp, res, _i, _len;
      res = [];
      for (_i = 0, _len = raws.length; _i < _len; _i++) {
        comp = raws[_i];
        res.push(new comp());
      }
      return res;
    },
    findByType: function(type) {
      return $filter('filter')(this.getAll(), {
        type: type
      }, true);
    },
    findTopLevelOnly: function() {
      return $filter('filter')(this.getAll(), {
        topLevelOnly: true
      }, true);
    },
    findNonTopLevelOnly: function() {
      var comp, result, _i, _len, _ref;
      result = [];
      _ref = this.getAll();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        comp = _ref[_i];
        if (!comp.topLevelOnly) {
          result.push(comp);
        }
      }
      return result;
    },
    findById: function(id) {
      var all, res;
      if (!id) {
        return null;
      }
      all = this.getAll();
      res = $filter('filter')(all, {
        id: id
      }, true);
      if (res.length > 0) {
        return res[0];
      } else {
        return null;
      }
    }
  };
});

angular.module('faber').factory('configService', function($rootScope) {
  var config;
  config = {
    expanded: true,
    prefix: 'faber',
    components: [RichTextComponent, OrderedListComponent]
  };
  faber.init = this.init;
  return {
    init: function(newConfig) {
      angular.extend(config, newConfig);
      return $rootScope.$broadcast('ConfigUpdated', config);
    },
    get: function() {
      return config;
    }
  };
});

angular.module('faber').factory('contentService', function($rootScope, faberConfig) {
  var content;
  content = {
    blocks: []
  };
  return {
    init: function(initial) {
      return content = initial;
    },
    clear: function() {
      return content.blocks = [];
    },
    getAll: function() {
      return content.blocks;
    },
    "import": function(json) {
      var imported;
      imported = angular.fromJson(json);
      if (angular.isArray(imported)) {
        content.blocks = imported;
        $rootScope.$broadcast('imported', content.blocks);
        return true;
      } else {
        return false;
      }
    },
    "export": function() {
      var json;
      json = angular.toJson(content.blocks);
      $rootScope.$broadcast('exported', json);
      return json;
    },
    save: function() {
      if (angular.isDefined(Storage)) {
        return localStorage.setItem("" + (faberConfig.prefix || 'faber') + ".data", angular.toJson(content.blocks));
      }
    },
    load: function() {
      var json;
      if (angular.isDefined(Storage)) {
        json = localStorage.getItem("" + (faberConfig.prefix || 'faber') + ".data") || [];
        this["import"](json);
        return json;
      } else {
        return [];
      }
    },
    removeSavedData: function() {
      return localStorage.removeItem("" + (faberConfig.prefix || 'faber') + ".data");
    }
  };
});
