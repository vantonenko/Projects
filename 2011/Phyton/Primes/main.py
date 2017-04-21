#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
from google.appengine.ext import webapp
from google.appengine.ext.webapp import util

import time
from threading import Thread

debug = 0

class PrimesThread(Thread):

    def __init__ (self,n):
        Thread.__init__(self)
        self.n = n
        self.result = 0
    
    def run(self):
        global debug
    
        debug = debug + 1
    
        s = [1]*(self.n + 1)
        
        i = 2
        while i * i <= self.n:
            if s[i] == 1:
                j = i * i
                while j <= self.n:
                    s[j] = 0
                    j = j + i
            i = i + 1
        
        count = 0
        for el in s:
            if el:
                count = count + 1
                
        self.result = count
        
        debug = debug - 1

class MainHandler(webapp.RequestHandler):
    
    def multiThread(self, n, t):
        start = time.clock()
        
        th = [0] * t
        
        for i in range(t):
            th[i] = PrimesThread(n)
            th[i].start()

        while debug != 0:
            time.sleep(0.5)
        
        for e in th:
            self.response.out.write('Quantity by thread is %d '%e.result)
        self.response.out.write(' Spent time is: %f'%(time.clock() - start))
    
    def singleThread(self, n):
        start = time.clock()
        
        s = [1]*(n + 1)
        
        i = 2
        while i * i <= n:
            if s[i] == 1:
                j = i * i
                while j <= n:
                    s[j] = 0
                    j = j + i
            i = i + 1
        
        count = 0
        
        for el in s:
            if el:
                count = count + 1
        
        self.response.out.write('The quantity of prime numbers in the range 1..%d is: %d'%(n, count))
        self.response.out.write(' Spent time is: %f'%(time.clock() - start))

    def get(self):
        try:
            n = int(self.request.get('n'))
        except:
            n = 10000000
            
        try:
            t = int(self.request.get('t'))
        except:
            t = 1
        
        if t == 1:
            self.singleThread(n)
        else:
            self.multiThread(n, t)


def main():
    application = webapp.WSGIApplication([('/', MainHandler)],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()
