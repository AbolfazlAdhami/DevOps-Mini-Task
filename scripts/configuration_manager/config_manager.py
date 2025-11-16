import yaml
import json
import os
import ast
from typing import Dict, Any

class ConfigManager:
        def __init__(self, yaml_path: str = "config.yaml", json_path: str = "config.json"):
                self.yaml_path = yaml_path
                self.json_path = json_path
                self.config: Dict[str, Any] = {}
                self.load_all()

        def load_yaml(self):
                """  Load Configs from YAML file   """
                if os.path.exists(self.yaml_path):
                        try:
                                with open(self.yaml_path, 'r', encoding='utf-8')as f:
                                        data = yaml.safe_load(f) or {}
                                        self.config.update(data)
                                        print(f'Load YAML Config from {self.yaml_path}')
                        except Exception as e:
                                print(f'Error to load YAML File {e}')

                else:
                        print(f'Could not found {self.yaml_path}, use default values')

        def save_yaml(self):
                """ Save new configs in YAML file  """
                try:
                        with open(self.yaml_path, 'w', encoding='utf-8') as f:
                                yaml.safe_dump(
                                self.config, f, allow_unicode=True, sort_keys=False)
                                print(f'Save configs in {self.yaml_path}')
                except Exception as e:
                        print(f'Error to saving YAML: {e}')

        def load_josn(self):
                if os.path.exists(self.json_path):
                        try:
                                with open(self.json_path, 'r', encoding='utf-8') as f:
                                        data = json.load(f)
                                        self.config.update(data)
                                        print(f'Load JSON Config from {self.json_path}')
                        except Exception as e:
                                print(f'Error to Load JSON: {e}')

        def save_json(self):
                try:
                        with open(self.json_path, 'r', encoding='utf-8') as f:
                                json.dump(self.config, f, ensure_ascii=False, indent=4)
                                print(f'Save configs in {self.yaml_path} ')
                except Exception as e:
                        print(f'Error to saving JSON: {e}')

        def load_all(self):
                self.load_yaml()
                self.load_josn()

        def save_all(self):
                self.save_yaml()
                self.save_json()

        def add_config(self, key: str, value: Any):
                '''Add New Config'''
                self.config[key]=value
                print(f'Set "{key}" Added/Updated: {value} ')

        def get(self, key: str, default=None):
                ''' Get a  Config by its key '''
                return self.config.get(key,default)
        
        
        def update_from_input(self):
                '''  Update Config from user input   '''
                print('for quit type "exti" ')
                while True:
                        key=input("(key):").strip()
                        if key.lower()=='exit':
                                break
                        if not key:
                                print('key not be empty!')
                                continue
                        value = input("(value):").strip()
                        if value.lower()=='true':
                                value =True
                        elif value.lower()=='false':
                                value =False
                        elif value.isdigit():
                                value=int(value)
                        elif value.replace('.','',1).isdigit():
                                value=float(value)
                        elif value.startswith('[') or value.startswith('{'):
                                try:
                                        value = ast.literal_eval(value)
                                except:
                                        pass
                        self.add_config(key,value)
                self.save_all()        


        def show_config(self):
                '''Show all Configs'''
                print("\nCurrent Configs:")
                for k, v in self.config.items():
                        print(f"  {k}: {v}")
                print()







if __name__ == '__main__':
        config=ConfigManager()
        
        config.show_config()
        config.add_config("API_KEY", "34455123klsswadwd123")
        config.add_config("USER_NAME", "admin")
        config.add_config("port", 3000)
        config.save_all()
        config.update_from_input()
        config.show_config()