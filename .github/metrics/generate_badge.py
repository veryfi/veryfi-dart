def main():

    import os

    with open('../../coverage/lcov.info') as file:
        code_coverage = get_code_coverage(file)
        verify_unit_tests(code_coverage)
        code_coverage, code_coverage_color = number_to_badge(code_coverage)
        os.system("wget --output-document=code_coverage.svg https://img.shields.io/badge/code%20coverage-{}-{}".format
                  (code_coverage, code_coverage_color))


def get_code_coverage(file):

    import re

    file_lines = file.read().splitlines()
    file.close()
    lines, lines_covered = 0.0, 0.0
    for line in file_lines:
        if line.startswith('DA'):
            lines += 1.0
            if not line.endswith('0'):
                lines_covered += 1.0
    return lines_covered / lines


def number_to_badge(number):
    color = get_color(number)
    if number == 1:
        return "100%25", color
    number *= 100
    return str(round(number, 1)) + "%25", color


def get_color(number):

    if number < 0.6:
        return "red"
    if number < 0.8:
        return "yellow"
    if number < 0.92:
        return "green"
    return "brightgreen"


def verify_unit_tests(number):

    print(number)
    if number < 0.85:
        print("Code coverage < 85%")
        exit(-1)


if __name__ == "__main__":

    main()
