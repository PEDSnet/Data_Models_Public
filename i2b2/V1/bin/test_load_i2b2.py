from contextlib import contextmanager
from cStringIO import StringIO
import sys
import tempfile
import unittest
import load_i2b2


@contextmanager
def captured_output():
    """Usage: with captured_output() as (out, err): foo()"""
    new_out, new_err = StringIO(), StringIO()
    old_out, old_err = sys.stdout, sys.stderr
    try:
        sys.stdout, sys.stderr = new_out, new_err
        yield sys.stdout, sys.stderr
    finally:
        sys.stdout, sys.stderr = old_out, old_err


class TestUsage(unittest.TestCase):

    def test_empty_usage(self):
        sys.argv = ['prog']
        with self.assertRaises(SystemExit):
            with captured_output() as (out, err):
                load_i2b2.main()
        self.assertIn('too few arguments', err.getvalue())

    def test_empty_usage(self):
        sys.argv = ['prog']
        with self.assertRaises(SystemExit):
            with captured_output() as (out, err):
                load_i2b2.main()
        self.assertIn('too few arguments', err.getvalue())

    def test_with_site(self):
        sys.argv = ['prog', 'stlouis']
        args = load_i2b2.get_args()
        self.assertEqual(args.site, 'stlouis')

    def test_invalid_site(self):
        sys.argv = ['prog', 'chop']
        with self.assertRaisesRegexp(ValueError, 'nvalid'):
            args = load_i2b2.get_args()

    def test_root_dir(self):
        root_dir = tempfile.gettempdir()
        sys.argv = ['prog', '--root-dir={0}'.format(root_dir), 'nemours']
        args = load_i2b2.get_args()
        self.assertEqual(args.root_dir, root_dir)
