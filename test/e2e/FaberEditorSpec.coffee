describe 'Faber Editor', ->

  beforeEach ->
    targetUrl = '/'
    browser.ignoreSynchronization = true
    browser.get targetUrl
#    browser.wait ()->
#      browser.driver.getCurrentUrl().then (url)->
#        targetUrl == url
#    , 2000, 'It\'s taking too long to load ' + targetUrl + '!'

  addRichText = ->
    richTextButton = element(protractor.By.buttonText('Rich Text'))
    richTextButton.click()

  addElement = ->
    elementButton = element(protractor.By.buttonText('Element Component'))
    elementButton.click()

  selectOption = (selectList, item)->
    desiredOption = null

    selectList.findElements(protractor.By.tagName('option'))
    .then (options)->
      options.some (option)->
        option.getText().then (text)->
          console.log item, text
          if item is text
            desiredOption = option
            return true
        return false
    .then ()->
      desiredOption.click() if desiredOption

  describe 'when initialised', ->
    components = protractor.By.tagName('faber-components')

    it 'should only show one component list', ->
      expect(element.all(components).count()).toEqual 1

    it 'should show all default element components', ->
      expect(element(components).element.all(protractor.By.repeater('comp in components')).count()).toEqual 2

    it 'should show one group button', ->
      expect(element(components).element.all(protractor.By.css('.faber-group-button')).count()).toEqual 1

    it 'should not have any blocks', ->
      expect(element.all(protractor.By.repeater('block in blocks')).count()).toEqual 0

  describe 'component list', ->
    it 'should toggle', ->
      components = protractor.By.tagName('faber-components')
      $componentsClick = element(components).element(protractor.By.css('div'))
      $plusIcon = element(components).element(protractor.By.css('.faber-icon-plus'))

      expect($plusIcon.isPresent()).toBeFalsy()

      $componentsClick.click()

      expect($plusIcon.isPresent()).toBeTruthy()

      $componentsClick.click()

      expect($plusIcon.isPresent()).toBeFalsy()

  describe 'when a element component button is clicked', ->
    it 'should add an element block', ->
      addRichText()

      elementBlock = protractor.By.tagName('faber-element-block')
      richTextBlock = protractor.By.css('.rich-text')

      expect(element.all(protractor.By.repeater('data in block.blocks')).count()).toEqual 1
      expect(element.all(elementBlock).count()).toEqual 1
      expect(element(elementBlock).element.all(richTextBlock).count()).toEqual 1

  describe 'when group button is clicked', ->
    groupBlock = null
    $groupBlock = null

    beforeEach ->
      $groupButton = element(protractor.By.buttonText('Group'))
      $groupButton.click()
      groupBlock = protractor.By.tagName('faber-group-block')
      $groupBlock = element(groupBlock)

    describe 'group block', ->
      it 'should be added', ->
        expect(element.all(protractor.By.repeater('data in block.blocks')).count()).toEqual 1
        expect(element.all(groupBlock).count()).toEqual 1

      it 'should set the first available group component', ->
        expect($groupBlock.element(protractor.By.selectedOption('currentComponent')).getText()).toBe 'Ordered List'

      it 'should show \'item\' button', ->
        $itemButton = element(protractor.By.buttonText('Item'))

        expect($itemButton.isPresent()).toBeTruthy()
        expect($itemButton.isDisplayed()).toBeTruthy()

      it 'should be able to switch to preview mode and switch back to edit mode', ->
        block = protractor.By.tagName('faber-block')

        # mouse over to the block so the action buttons are visible
        # --- mouseMove doesn't work on Safari
        # browser.actions().mouseMove(element(block)).perform()

        # click the block first so the action buttons are visible
        element(block).element(protractor.By.css('.faber-group-block')).click()

        $preview = element(block).element(protractor.By.css('button[title="Preview"]'))

        expect($preview.isPresent()).toBeTruthy()
        expect($groupBlock.element(protractor.By.binding('{{component.name}}')).isDisplayed()).toBeTruthy()
        expect($groupBlock.element(protractor.By.tagName('faber-components')).isDisplayed()).toBeTruthy()
        expect($groupBlock.element(protractor.By.tagName('faber-component-renderer')).isPresent()).toBeFalsy()

        $preview.click()
        $edit = element(block).element(protractor.By.css('button[title="Edit"]'))

        expect($edit.isPresent()).toBeTruthy()
        expect($groupBlock.element(protractor.By.binding('{{component.name}}')).isDisplayed()).toBeFalsy()
        expect($groupBlock.element(protractor.By.tagName('faber-components')).isDisplayed()).toBeFalsy()
        expect($groupBlock.element(protractor.By.tagName('faber-component-renderer')).isPresent()).toBeTruthy()

        $edit.click()
        $preview = element(block).element(protractor.By.css('button[title="Preview"]'))

        expect($preview.isPresent()).toBeTruthy()
        expect($groupBlock.element(protractor.By.binding('{{component.name}}')).isDisplayed()).toBeTruthy()
        expect($groupBlock.element(protractor.By.tagName('faber-components')).isDisplayed()).toBeTruthy()
        expect($groupBlock.element(protractor.By.tagName('faber-component-renderer')).isPresent()).toBeFalsy()

      it 'should be able to change to different group component', ->
        $groupSelect = $groupBlock.element(protractor.By.model('currentComponent'))

        expect($groupSelect.element.all(protractor.By.css('option')).count()).toEqual 2

        $groupSelect.element(protractor.By.css('option[value="1"]')).click()

        expect(element.all(groupBlock).count()).toEqual 1
        expect($groupBlock.element(protractor.By.selectedOption('currentComponent')).getText()).toBe 'Group Component'

    describe '\'item\' button', ->
      it 'should add a group item block', ->
        $itemButton = element(protractor.By.buttonText('Item'))
        $itemButton.click()

        expect($groupBlock.element.all(protractor.By.repeater('data in block.blocks')).count()).toEqual 1

    describe 'group item block', ->
      $itemBlock = null

      beforeEach ->
        $itemButton = element(protractor.By.buttonText('Item'))
        $itemButton.click()
        $itemBlock = $groupBlock.element(protractor.By.tagName('faber-group-item-block'))

      it 'should have title field', ->
        expect($groupBlock.element.all(protractor.By.tagName('faber-group-item-block')).count()).toEqual 1
        expect($itemBlock.element(protractor.By.model('block.title')).isPresent()).toBeTruthy()

      describe 'components', ->
        $components = null

        beforeEach ->
          $components = $itemBlock.element(protractor.By.tagName('faber-components'))

        it 'should be able to add component blocks', ->
          expect($components.isPresent()).toBeTruthy()
          expect($components.isDisplayed()).toBeTruthy()
          expect($components.element.all(protractor.By.tagName('button')).count()).toEqual 2

        it 'should be able to add element blocks', ->
          expect($components.element.all(protractor.By.repeater('comp in components')).count()).toEqual 2

        it 'should not be able to add group blocks', ->
          expect($components.element(protractor.By.css('.faber-group-button')).isPresent()).toBeFalsy()

      it 'should be able to collapse and expand', ->
        block = protractor.By.tagName('faber-block')

        addRichText()

        $itemBlock.click()
        $collapse = $groupBlock.element(block).element(protractor.By.css('button[title="Collapse"]'))

        expect($collapse.isPresent()).toBeTruthy()
        expect($itemBlock.element(protractor.By.repeater('data in block.blocks')).isPresent()).toBeTruthy()
        expect($itemBlock.element.all(protractor.By.tagName('faber-block')).count()).toEqual 1

        $collapse.click()
        $expand = $groupBlock.element(block).element(protractor.By.css('button[title="Expand"]'))

        expect($collapse.isPresent()).toBeFalsy()
        expect($expand.isPresent()).toBeTruthy()
        expect($itemBlock.element(protractor.By.repeater('data in block.blocks')).isPresent()).toBeFalsy()

        $expand.click()
        $collapse = $groupBlock.element(block).element(protractor.By.css('button[title="Collapse"]'))

        expect($expand.isPresent()).toBeFalsy()
        expect($collapse.isPresent()).toBeTruthy()
        expect($itemBlock.element(protractor.By.repeater('data in block.blocks')).isPresent()).toBeTruthy()
        expect($itemBlock.element.all(protractor.By.tagName('faber-block')).count()).toEqual 1

      describe 'on group edit mode', ->
        it 'should be able to change the order of component blocks', ->

        it 'should be able to remove component blocks', ->

      describe 'on group preview mode', ->
        it 'should show the correct number of rendered component blocks', ->
          block = protractor.By.tagName('faber-block')
          $components = $itemBlock.element(protractor.By.tagName('faber-components'))

          addRichText()
          $components.element(protractor.By.tagName('div')).click()
          addRichText()
          $components.element(protractor.By.tagName('div')).click()
          addRichText()

          expect($itemBlock.element.all(protractor.By.tagName('faber-block')).count()).toEqual 3

          element(block).element(protractor.By.css('.faber-group-block')).click()
          $preview = element(block).element(protractor.By.css('button[title="Preview"]'))
          $preview.click()

          expect($groupBlock.element.all(protractor.By.tagName('faber-render')).count()).toEqual 1
          expect($groupBlock.element(protractor.By.tagName('faber-render')).element.all(protractor.By.tagName('faber-component-renderer')).count()).toEqual 3

  describe 'block', ->
    beforeEach ->
      $components = element(protractor.By.tagName('faber-components'))

      # ['block 1', 'block 2', 'block 3']
      # the following insert blocks on top
      addElement()
      element(protractor.By.css('.element-component input')).sendKeys 'block 3'

      $components.element(protractor.By.tagName('div')).click()
      addElement()
      element(protractor.By.css('.element-component input')).sendKeys 'block 2'

      $components.element(protractor.By.tagName('div')).click()
      addElement()
      element(protractor.By.css('.element-component input')).sendKeys 'block 1'

    it 'should be able to change order', ->
      element.all(protractor.By.tagName('faber-block')).then (blocks)->
        expect(blocks.length).toEqual 3
        expect(blocks[0].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 1'
        expect(blocks[1].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 2'
        expect(blocks[2].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 3'

        blocks[2].findElement(protractor.By.tagName('div')).click()

        blocks[2]
        .findElement(protractor.By.model('$parent.$index')) # <select>
        .findElement(protractor.By.css('option[value="1"]')) # <option>
        .then (option)->
          option.click()

      element.all(protractor.By.tagName('faber-block')).then (blocks)->
        expect(blocks[0].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 1'
        expect(blocks[1].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 3'
        expect(blocks[2].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 2'

    it 'should be able to be removed', ->
      # SafariDriver does not support alert dialog
      browser.getCapabilities().then (cap)->
        unless cap.caps_.browserName.toLowerCase() is 'safari'
          block2 = element(protractor.By.repeater('data in block.blocks').row(1))
          block2.findElement(protractor.By.tagName('div')).click()
          block2.findElement(protractor.By.css('button[title="Remove"]')).click()

          alertDialog = browser.switchTo().alert()
          alertDialog.accept()

          element.all(protractor.By.tagName('faber-block')).then (blocks)->
             expect(blocks.length).toEqual 2
             expect(blocks[0].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 1'
             expect(blocks[1].findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 3'

  describe 'when content is imported', ->
    blocks = null
    groupBlock = null

    beforeEach ->
      browser.executeScript ()->
        faber.import '[
          {"component":"element-component","content":"block 1"},
          {"component":"element-component","content":"block 2"},
          {
            "component":"ordered-list",
            "blocks":[
              {
                "title":"item 1",
                "blocks":[
                  {"component":"element-component","content":"item 1-1"},
                  {"component":"element-component","content":"item 1-2"},
                  {"component":"element-component","content":"item 1-3"}
                ]
              },
              {
                "title":"item 2",
                "blocks":[
                  {"component":"element-component","content":"item 2-1"},
                  {"component":"element-component","content":"item 2-2"}
                ]
              }
            ]
          },
          {"component":"element-component","content":"block 3"}
        ]'

      blocks = element.all(protractor.By.css('faber-editor > .faber-blocks > div[ng-repeat="data in block.blocks"] > faber-block'))
      groupBlock = blocks.get 2

    describe 'imported blocks', ->
      it 'should process the data correctly', ->
        expect(blocks.count()).toEqual 4
        expect(blocks.get(0).findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 1'
        expect(blocks.get(1).findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 2'
        expect(blocks.get(3).findElement(protractor.By.model('block.content')).getAttribute('value')).toBe 'block 3'

        groupBlock.findElements(protractor.By.tagName('faber-group-block')).then (groups)->
          expect(groups.length).toEqual 1

        groupBlock.findElements(protractor.By.repeater('b in block.blocks')).then (items)->
          expect(items.length).toEqual 2

          items[0].findElements(protractor.By.repeater('block in data.blocks')).then (elements)->
            expect(elements.length).toBe 3

          items[1].findElements(protractor.By.repeater('block in data.blocks')).then (elements)->
            expect(elements.length).toBe 2

    describe 'group blocks', ->
      it 'should be on preview mode', ->
        block = groupBlock.findElement(protractor.By.tagName('faber-group-block'))

        expect(block.isDisplayed()).toBeTruthy()
        expect(block.isElementPresent(protractor.By.tagName('faber-component-renderer'))).toBeTruthy()
        expect(block.findElement(protractor.By.tagName('faber-component-renderer')).isDisplayed()).toBeTruthy()
        expect(groupBlock.isElementPresent(protractor.By.css('button[title="Preview"]'))).toBeFalsy()

    describe 'group block items', ->
      it 'should be collapsed', ->
        groupBlock.findElement(protractor.By.tagName('div')).click()
        groupBlock.findElement(protractor.By.css('button[title="Edit"]')).click()

        expect(groupBlock.isElementPresent(protractor.By.css('button[title="Preview"]'))).toBeTruthy()
        expect(groupBlock.isElementPresent(protractor.By.tagName('faber-components'))).toBeTruthy()

        groupBlock.findElements(protractor.By.css('faber-group-item-block faber-block')).then (results)->
          expect(results.length).toEqual 0
