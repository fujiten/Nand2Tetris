# let's go to make Parser!

class JackAnalyzer:
  def __init__(self, name):
    self._is_directory = False
    self.name = name

  def start_analyze(self):
    f = open(f'{self.name}.xml', "x")
    f.close()
