# restore format tests

test-csv and test-yaml fail: Python3???

setup:
	install python3 ???
	@rpm -q --quiet python2-pyyaml || sudo dnf -y install python2-pyyaml


# spin-off

```
	mpp < f.mpp > f.md
```
