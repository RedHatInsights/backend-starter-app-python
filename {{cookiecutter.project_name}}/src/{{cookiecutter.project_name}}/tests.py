from django.test import TestCase


class ExampleTest(TestCase):
    def setUp(self):
        pass

    def testHelloWorld(self):
        print("hello world!")
        self.assertEqual(1, 1)
