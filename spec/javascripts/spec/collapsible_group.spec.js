describe('A collapsible group module', function () {
  'use strict'

  var group,
    element

  beforeEach(function () {
    // Stub a bootstrap collapse method on jQuery
    $.fn.collapse = function (str) {
      if (str === 'show') {
        $(this).addClass('in')
        element.trigger('shown.bs.collapse')
      } else if (str === 'hide') {
        $(this).removeClass('in')
        element.trigger('hidden.bs.collapse')
      }
    }

    element = $('<div data-expand-text="Expand" data-collapse-text="Collapse">' +
      '<a href="#" class="js-toggle-all">Starting text</a>' +
      '<div class="collapse"></div>' +
      '<div class="collapse"></div>' +
      '<div class="collapse"></div>' +
    '</div>')

    $('body').append(element)

    group = new GOVUKAdmin.Modules.CollapsibleGroup()
  })

  afterEach(function () {
    element.remove()

    // Delete bootstrap stub
    delete $.fn.collapse
  })

  describe('when first initialized', function () {
    describe('and all items are open', function () {
      beforeEach(function () {
        element.find('.collapse').addClass('in')
        group.start(element)
      })

      it('changes the trigger text to the collapse text', function () {
        expect(element.find('.js-toggle-all').text()).toBe('Collapse')
      })
    })

    describe('and some items are open', function () {
      beforeEach(function () {
        element.find('.collapse').removeClass('in')
        element.find('.collapse').first().addClass('in')
        group.start(element)
      })

      it('changes the trigger text to the collapse text', function () {
        expect(element.find('.js-toggle-all').text()).toBe('Collapse')
      })
    })

    describe('and all items are closed', function () {
      beforeEach(function () {
        element.find('.collapse').removeClass('in')
        group.start(element)
      })

      it('changes the trigger text to the expand text', function () {
        expect(element.find('.js-toggle-all').text()).toBe('Expand')
      })
    })
  })

  describe('when already running', function () {
    beforeEach(function () {
      group.start(element)
    })

    describe('when all items are closed and the toggle is clicked', function () {
      beforeEach(function () {
        element.find('.js-toggle-all').trigger('click')
      })

      it('expands all items', function () {
        expect(element.find('.collapse.in').length).toBe(3)
      })

      it('then shows the collapse text', function () {
        expect(element.find('.js-toggle-all').text()).toBe('Collapse')
      })
    })

    describe('when all items are open and the toggle is clicked', function () {
      beforeEach(function () {
        element.find('.collapse').addClass('in')
        expect(element.find('.collapse.in').length).toBe(3)
        element.find('.js-toggle-all').trigger('click')
      })

      it('collapses all items', function () {
        expect(element.find('.collapse.in').length).toBe(0)
      })

      it('then shows the expand text', function () {
        expect(element.find('.js-toggle-all').text()).toBe('Expand')
      })
    })

    describe('when at least one item is open and the toggle is clicked', function () {
      beforeEach(function () {
        element.find('.collapse').first().addClass('in')
        expect(element.find('.collapse.in').length).toBe(1)
        element.find('.js-toggle-all').trigger('click')
      })

      it('collapses all items', function () {
        expect(element.find('.collapse.in').length).toBe(0)
        expect(element.find('.js-toggle-all').text()).toBe('Expand')
      })
    })

    describe('when a user manually collapses or expands items', function () {
      it('updates the link text', function () {
        element.find('.collapse').first().addClass('in')
        element.trigger('shown.bs.collapse')
        expect(element.find('.js-toggle-all').text()).toBe('Collapse')

        element.find('.collapse').first().removeClass('in')
        element.trigger('hidden.bs.collapse')
        expect(element.find('.js-toggle-all').text()).toBe('Expand')
      })
    })

    describe('when a new group is added or removed', function () {
      it('updates the link text', function () {
        element.find('.collapse').first().addClass('in')
        element.trigger('nested:fieldAdded')
        expect(element.find('.js-toggle-all').text()).toBe('Collapse')

        element.find('.collapse.in').first().hide()
        element.trigger('nested:fieldRemoved')
        expect(element.find('.js-toggle-all').text()).toBe('Expand')
      })
    })
  })
})
