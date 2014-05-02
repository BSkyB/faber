describe 'Faber Editor', ->

  beforeEach ->
    targetUrl = 'http://localhost:1337/'
    browser.ignoreSynchronization = true
    browser.get targetUrl
    browser.wait ()->
      browser.driver.getCurrentUrl().then (url)->
        targetUrl == url
    , 2000, 'It\'s taking too long to load ' + targetUrl + '!'

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
      richTextButton = element(protractor.By.buttonText('Rich Text'))
      richTextButton.click()

      elementBlock = protractor.By.tagName('faber-element-block')
      richTextBlock = protractor.By.css('.rich-text')

      expect(element.all(protractor.By.repeater('data in block.blocks')).count()).toEqual 1
      expect(element.all(elementBlock).count()).toEqual 1
      expect(element(elementBlock).element.all(richTextBlock).count()).toEqual 1

  describe 'when group button is clicked', ->
    beforeEach ->
      $groupButton = element(protractor.By.buttonText('Group'))
      $groupButton.click()
      @groupBlock = protractor.By.tagName('faber-group-block')

    describe 'group block', ->
      it 'should be added', ->
        expect(element.all(protractor.By.repeater('data in block.blocks')).count()).toEqual 1
        expect(element.all(@groupBlock).count()).toEqual 1

      it 'should set the first available group component', ->
        expect(element(@groupBlock).element(protractor.By.selectedOption('currentComponent')).getText()).toBe 'Ordered List'

      it 'should show \'item\' button', ->
        $itemButton = element(protractor.By.buttonText('Item'))

        expect($itemButton.isPresent()).toBeTruthy()
        expect($itemButton.isDisplayed()).toBeTruthy()

      describe 'switch mode', ->
        it 'should be able to switch to preview mode', ->
          # TODO

      it 'should be able to change to different group component', ->
        $groupSelect = element(@groupBlock).element(protractor.By.model('currentComponent'))

        expect($groupSelect.element.all(protractor.By.css('option')).count()).toEqual 2

        $groupSelect.element(protractor.By.css('option[value="1"]')).click()

        expect(element.all(@groupBlock).count()).toEqual 1
        expect(element(@groupBlock).element(protractor.By.selectedOption('currentComponent')).getText()).toBe 'Group Component'

    describe '\'item\' button', ->
      it 'should add a group item block', ->
        $itemButton = element(protractor.By.buttonText('Item'))
        $itemButton.click()

        expect(element(@groupBlock).element.all(protractor.By.repeater('data in block.blocks')).count()).toEqual 1

    describe 'group item block', ->
      beforeEach ->
        $itemButton = element(protractor.By.buttonText('Item'))
        $itemButton.click()

